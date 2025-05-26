use std::any::Any;
use std::collections::HashMap;
use std::fs::File;
use std::net::SocketAddr;
use std::path::PathBuf;
use std::time::Duration;
use anyhow::{bail, Result};
use flutter_rust_bridge::for_generated::futures::StreamExt;
// use flutter_rust_bridge::frb;
use quic_rpc::{RpcClient, RpcMessage, Service};
use quic_rpc::transport::quinn::{make_insecure_client_endpoint, QuinnConnector};
use sandbarclient_lib::config::{read_config_file, write_config_file, Config, RelayNode, SandbarFsConfig};
use sandbarclient_lib::consts::{RPC_DEFAULT_PORT, SBC_RPC_DEFAULT_PORT};
use sandbarclient_lib::node::start_listen_with_config_file;
use sandbarclient_lib::rpc::client::blobs_client::{WrapOption};
use sandbarclient_lib::utils::remove_pid_file;
use sandbarclient_type::sandbar_node::{SandbarNodeRequest, SandbarNodeResponse, SandbarNodeService, ShutdownSandbarNode};
use tokio::time::sleep;
use tokio_util::sync::CancellationToken;
use sandbarclient_lib::utils::blobs_util::SetTagOption;
use sandbarclient_lib::rpc::protos::blobs_rpc_proto;
use sandbarclient_lib::blobs_provider;
use sandbarclient_lib::rpc::protos::blobs_rpc_proto::blobs::AddPathResponse;
use serde::{Deserialize, Serialize};
use crate::frb_generated::StreamSink;

pub(crate) async fn load_config_from_file(config_file_path: String) -> Result<Config> {
    if PathBuf::from(config_file_path.clone()).exists() == false {
        return Err(anyhow::anyhow!("config file not found"));
    }

    Ok(read_config_file(config_file_path).await?)
}

pub(crate) async fn make_sb_rpc_client(config_file_path: String, ) -> Result<
        RpcClient<
            SandbarNodeService,
            QuinnConnector<SandbarNodeResponse, SandbarNodeRequest>>>{

    let Config {
        sandbar_fs: SandbarFsConfig {
            sb_rpc_port,
            ..
        },
        ..
    } = load_config_from_file(config_file_path).await?;

    let server_addr: SocketAddr = format!("127.0.0.1:{}", sb_rpc_port).parse()?;
    let endpoint = make_insecure_client_endpoint("0.0.0.0:0".parse()?)?;

    let conn: QuinnConnector<SandbarNodeResponse, SandbarNodeRequest> = QuinnConnector::new(endpoint, server_addr, "localhost".to_string());
    let client: RpcClient<SandbarNodeService, QuinnConnector<SandbarNodeResponse, SandbarNodeRequest>> = RpcClient::new(conn);

    Ok(client)
}

pub(crate) async fn make_blobs_rpc_client(config_file_path: String,) -> Result<
    RpcClient<
        blobs_rpc_proto::RpcService,
        QuinnConnector<blobs_rpc_proto::Response, blobs_rpc_proto::Request>>>{
    let Config {
        sandbar_fs: SandbarFsConfig {
            rpc_port,
            ..
        },
        ..
    } = load_config_from_file(config_file_path).await?;

    let server_addr: SocketAddr = format!("127.0.0.1:{}", rpc_port).parse()?;
    let endpoint = make_insecure_client_endpoint("0.0.0.0:0".parse()?)?;

    let conn: QuinnConnector<blobs_rpc_proto::Response, blobs_rpc_proto::Request> = QuinnConnector::new(endpoint, server_addr, "localhost".to_string());
    let client: RpcClient<blobs_rpc_proto::RpcService, QuinnConnector<blobs_rpc_proto::Response, blobs_rpc_proto::Request>> = RpcClient::new(conn);
    Ok(client)
}

pub async fn create_sandbar_node(
    config_file_path: String, parent_dir_auto_create: bool,
    pal_cb_private_key_b64: String,
    pal_cb_public_key_b64: String,
    rpc_port: Option<usize>,
    sb_rpc_port: Option<usize>,
    relay_nodes: Vec<String>,
    sbc_api_host: String,
) -> Result<String>{
    // Create Config
    let config_file_path = PathBuf::from(config_file_path);
    let parent_dir = config_file_path.parent().unwrap().to_path_buf();
    if config_file_path.exists() {
        bail!("The config file path <{:?}> already exists, can not create int target location.", config_file_path);
    }else{
        if parent_dir_auto_create {
            std::fs::create_dir_all(&parent_dir)?;
        }else{
            bail!("The config file path <{:?}> parent directory not exists.", config_file_path.as_path());
        }
    }
    let pid_file_path = parent_dir.join("sandbar.pid");

    let relay_nodes: Vec<RelayNode> = relay_nodes.iter().map(|node| {serde_json::from_str(node).unwrap()}).collect();
    let config = Config::builder()
        .pid_file(pid_file_path.to_str().unwrap().to_string())
        .sandbar_fs(
            SandbarFsConfig::builder()
                .in_place_threshold_bytes(0)
                .data_root(parent_dir.clone())
            .rpc_port(rpc_port.unwrap_or(RPC_DEFAULT_PORT))
            .sb_rpc_port(sb_rpc_port.unwrap_or(SBC_RPC_DEFAULT_PORT))
                .build())
        .standalone_mode(false)
        .pal_cb_private_key_b64(pal_cb_private_key_b64)
        .pal_cb_public_key_b64(pal_cb_public_key_b64)
        .relay_nodes(relay_nodes)
        .sbc_api_host(sbc_api_host)
        .build();

    write_config_file(&config_file_path, &config).await?;

    Ok(config_file_path.to_str().unwrap().to_string())
}

pub fn get_rpc_port() -> Result<usize> {
    Ok(8080)
}

pub async fn start_sandbar_node_service(config_file_path: String) -> Result<()> {
    println!("Start service from frb");
    let cancellation_token = CancellationToken::new();
    let _ = start_listen_with_config_file(config_file_path, cancellation_token.clone()).await;

    let sleep = sleep(Duration::from_secs(1));
    tokio::pin!(sleep);

    let cancellation_token_listen = cancellation_token.clone();
    loop {
        // println!("check cancellation_token_listen.cancelled():");
        tokio::select! {
            _ = cancellation_token_listen.cancelled() => {
                break;
            }
            _ = &mut sleep => {

            }
        }
    }
    Ok(())
}


pub async fn stop_sandbar_node_service(config_file_path: String) -> Result<()> {
    println!("Stop service from frb");
    let Config {
        pid_file,
        standalone_mode: _,
        sandbar_fs: SandbarFsConfig {
            rpc_port: _,
            sb_rpc_port,
            ..
        },
        ..
    } = read_config_file(config_file_path).await?;

    let server_addr: SocketAddr = format!("127.0.0.1:{}", sb_rpc_port).parse()?;
    let endpoint = make_insecure_client_endpoint("0.0.0.0:0".parse()?)?;

    let conn: QuinnConnector<SandbarNodeResponse, SandbarNodeRequest> = QuinnConnector::new(endpoint, server_addr, "localhost".to_string());
    let client: RpcClient<SandbarNodeService, QuinnConnector<SandbarNodeResponse, SandbarNodeRequest>> = RpcClient::new(conn);
    let s = client.rpc(ShutdownSandbarNode).await;
    println!("res: {:?}", s);

    remove_pid_file(pid_file).await?;

    Ok(())
}

// #[frb]
pub struct SandbarNodeStat {
    pub rpc_port: usize,
    pub sb_rpc_port: usize,
    pub running: bool,
}
pub async fn get_sandbar_node_stat(config_file_path: String) -> Result<SandbarNodeStat> {
    if PathBuf::from(config_file_path.clone()).exists() == false {
        return Err(anyhow::anyhow!("config file not found"));
    }
    let Config {
        pid_file,
        sandbar_fs: SandbarFsConfig {
            rpc_port,
            sb_rpc_port,
            ..
        },
        ..
    } = read_config_file(config_file_path).await?;
    Ok(SandbarNodeStat {
        rpc_port,
        sb_rpc_port,
        running: PathBuf::from(pid_file).exists()
    })
}


#[derive(Debug, Serialize, Deserialize, derive_more::Into)]
pub struct SandbarFsAddPathResponse {
    pub json_data: String,
    pub kind: String,
}

impl From<AddPathResponse> for SandbarFsAddPathResponse {
    fn from(value: AddPathResponse) -> Self {
        let kind = match &value.0 {
            blobs_provider::AddProgress::Found {..} => "Found".to_string(),
            blobs_provider::AddProgress::Progress {..} => "Progress".to_string(),
            blobs_provider::AddProgress::Done {..} => "Done".to_string(),
            blobs_provider::AddProgress::AllDone {..}  => "AllDone".to_string(),
            blobs_provider::AddProgress::Abort(_) => "Abort".to_string(),
        };

        Self {
            kind,
            json_data: serde_json::to_string(&value.0).expect("Failed to serialize AddPathResponse")
        }
    }
}

pub async fn add_path_to_sandbar_fs(
    s: StreamSink<SandbarFsAddPathResponse>,
    config_file_path: String,
    path: String,
    wrap_name: Option<String>) -> Result<()> {

    let path_file = File::open(path.clone()).expect("Failed to open file");
    let size = path_file.metadata()?.len();
    let in_place = if size > 1024*1000*500 {
        true
    } else {
        false
    };

    let msg = blobs_rpc_proto::blobs::AddPathRequest {
        path: PathBuf::from(path),
        in_place,
        tag: SetTagOption::Auto,
        wrap: match wrap_name {
            Some(name) => WrapOption::Wrap {
                name: Some(name)
            },
            None => WrapOption::NoWrap,
        }
    };
    println!("Msg: {:?}", msg);

    let client = make_blobs_rpc_client(config_file_path).await?;
    let mut res = client.server_streaming(msg).await?;
    while let Some(blob_resp) = res.next().await {
        match blob_resp {
            Ok(resp_info) => {
                println!("{:?}", resp_info);
                s.add(resp_info.into()).unwrap()
            },
            Err(e) => {
                println!("{:?}", e);
            }
        }
    }

    Ok(())
}
use std::net::SocketAddr;
use std::path::PathBuf;
use std::time::Duration;
use anyhow::{bail, Result};
// use flutter_rust_bridge::frb;
use quic_rpc::RpcClient;
use quic_rpc::transport::quinn::{make_insecure_client_endpoint, QuinnConnector};
use sandbarclient_lib::config::{read_config_file, write_config_file, Config, RelayNode, SandbarFsConfig};
use sandbarclient_lib::consts::{RPC_DEFAULT_PORT, SBC_RPC_DEFAULT_PORT};
use sandbarclient_lib::node::start_listen_with_config_file;
use sandbarclient_lib::utils::remove_pid_file;
use sandbarclient_type::sandbar_node::{SandbarNodeRequest, SandbarNodeResponse, SandbarNodeService, ShutdownSandbarNode};
use tokio::time::sleep;
use tokio_util::sync::CancellationToken;

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
    } = read_config_file(config_file_path).await.unwrap();

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
pub struct SandbarNodeConfig {
    pub rpc_port: usize,
    pub sb_rpc_port: usize,
    pub running: bool,
}
pub async fn get_sandbar_node_config(config_file_path: String) -> Result<SandbarNodeConfig> {
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
    } = read_config_file(config_file_path).await.unwrap();
    Ok(SandbarNodeConfig {
        rpc_port,
        sb_rpc_port,
        running: PathBuf::from(pid_file).exists()
    })
}

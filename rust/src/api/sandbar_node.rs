use std::net::SocketAddr;
use std::path::PathBuf;
use std::time::Duration;
use anyhow::Result;
use quic_rpc::RpcClient;
use quic_rpc::transport::quinn::{make_insecure_client_endpoint, QuinnConnector};
use sandbarclient_lib::config::{read_config_file, Config, SandbarFsConfig};
use sandbarclient_lib::node::start_listen_with_config_file;
use sandbarclient_type::sandbar_node::{SandbarNodeRequest, SandbarNodeResponse, SandbarNodeService, ShutdownSandbarNode};
use tokio::time::sleep;
use tokio_util::sync::CancellationToken;

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
    Ok(())
}

pub struct SandbarNodeConfig {
    pub rpc_port: usize,
    pub sb_rpc_port: usize,
}
pub async fn get_sandbar_node_config(config_file_path: String) -> Result<SandbarNodeConfig> {
    if PathBuf::from(config_file_path.clone()).exists() == false {
        return Err(anyhow::anyhow!("config file not found"));
    }
    let Config {
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
    })
}

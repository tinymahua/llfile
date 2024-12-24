use anyhow::Result;
use flutter_rust_bridge::frb;
use sysinfo::Disks;

#[frb]
pub struct DiskPartition {
    pub name: String,
    #[frb(name = "mountPoint")]
    pub mount_point: String,
}

#[frb(sync)]
pub fn get_disk_partitions() -> Result<Vec<DiskPartition>> {
    let disks = Disks::new_with_refreshed_list();
    let disk_partitions = disks
        .iter()
        .map(|x| DiskPartition {
            name: x.name().to_str().unwrap().to_string(),
            mount_point: x.mount_point().to_str().unwrap().to_string(),
        })
        .collect();
    Ok(disk_partitions)
}

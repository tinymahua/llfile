use crate::frb_generated::StreamSink;
use anyhow::Result;
use std::fs;
use chrono::prelude::*;
use chrono::DateTime;

pub struct FsEntity {
    pub name: String,
    pub is_dir: bool,
    pub date_created: String,
}


pub fn get_fs_entities(s: StreamSink<FsEntity>, root_path: String) -> Result<()> {
    if let Ok(entries) = fs::read_dir(root_path) {
        for entry in entries {
            if let Ok(entry) = entry {
                let entry_path = entry.path();
                let datetime: DateTime<Local> = entry.metadata()?.created()?.into();
                let fs_entry = FsEntity {
                    name: entry_path
                        .clone()
                        .file_name()
                        .unwrap()
                        .to_str()
                        .unwrap()
                        .to_string(),
                    is_dir: entry_path.is_dir(),
                    date_created: datetime.format("%Y/%m/%d %H:%M:%S").to_string(),
                };
                s.add(fs_entry).unwrap();
            }
        }
    }
    Ok(())
}


use serde_json::Value;
use std::env::current_dir;
use std::fs::{read_dir, File};
use std::io::Read;

use crate::package_managers::package_manager::{PackageManager, Parse};

fn read_package_json_pmr() -> Option<PackageManager> {
    let mut file = File::open("package.json").ok()?;

    let mut contents = String::new();
    if file.read_to_string(&mut contents).is_err() {
        return None;
    }

    let json_data: Value = serde_json::from_str(&contents).ok()?;

    let value = json_data
        .get("pmr")
        .and_then(|pmr_value| pmr_value.as_str().map(|pmr_string| pmr_string.to_string()))?;

    PackageManager::parse(&value).ok()
}

pub fn get_package_manager() -> Option<PackageManager> {
    if let Some(pm) = read_package_json_pmr() {
        return Some(pm);
    }

    let files = read_dir(current_dir().ok()?).ok()?;
    let lockfiles = files
        .filter_map(|entry| {
            let entry = entry.ok()?;

            if !entry.file_type().ok()?.is_file() {
                return None::<PackageManager>;
            }

            let filename = entry.file_name();
            let filename = filename.to_str()?;

            match filename {
                "package-lock.json" => Some(PackageManager::Npm),
                "yarn.lock" => Some(PackageManager::Yarn),
                "pnpm-lock.yaml" => Some(PackageManager::Pnpm),
                "bun.lockb" => Some(PackageManager::Bun),
                _ => None,
            }
        })
        .collect::<Vec<_>>();

    let lockfiles_len = lockfiles.len();
    if lockfiles_len > 1 {
        return None;
    }
    if lockfiles_len == 1 {
        return Some(lockfiles[0]);
    }

    None
}

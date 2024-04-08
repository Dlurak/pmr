use crate::package_managers::package_manager::PackageManager;

pub struct RemoveArgs {
    pub package_name: String,
}

impl PackageManager {
    pub fn remove(&self, args: RemoveArgs) -> Vec<String> {
        vec!["remove".to_string(), args.package_name]
    }
}

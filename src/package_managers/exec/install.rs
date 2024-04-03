use crate::package_managers::package_manager::PackageManager;

pub struct InstallArgs {}

enum InstallPart {
    Command,
}

struct Install {
    command: String,
    order: Vec<InstallPart>,
}

impl Install {
    fn list(&self, _args: &InstallArgs) -> Vec<String> {
        self.order
            .iter()
            .map(|part| match part {
                InstallPart::Command => Some(self.command.clone()),
            })
            .filter_map(|s| s)
            .collect()
    }
}

impl PackageManager {
    pub fn install(&self, args: InstallArgs) -> Vec<String> {
        let inst = match self {
            PackageManager::Yarn => Install {
                command: String::new(),
                order: vec![],
            },
            _ => Install {
                command: "install".to_string(),
                order: vec![InstallPart::Command],
            },
        };

        inst.list(&args)
    }
}

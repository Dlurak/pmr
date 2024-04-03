use crate::package_managers::package_manager::PackageManager;

pub struct AddArgs {
    pub package_name: String,
    pub global: bool,
}

enum AddPart {
    Command,
    GlobalFlag,
    PackageName,
}

struct Add {
    global: String,
    command: String,
    order: Vec<AddPart>,
}

impl Add {
    fn list(&self, args: &AddArgs) -> Vec<String> {
        self.order
            .iter()
            .map(|part| match part {
                AddPart::Command => Some(self.command.clone()),
                AddPart::GlobalFlag => {
                    if args.global {
                        Some(self.global.clone())
                    } else {
                        None
                    }
                }
                AddPart::PackageName => Some(format!("{}", args.package_name)),
            })
            .filter_map(|s| s)
            .collect()
    }
}

impl PackageManager {
    pub fn add(&self, args: AddArgs) -> Vec<String> {
        let default_order = vec![AddPart::Command, AddPart::GlobalFlag, AddPart::PackageName];

        let add = match self {
            PackageManager::Npm => Add {
                command: "install".to_string(),
                global: "-g".to_string(),
                order: default_order,
            },
            PackageManager::Pnpm => Add {
                command: "add".to_string(),
                global: "-g".to_string(),
                order: default_order,
            },
            PackageManager::Yarn => Add {
                command: "add".to_string(),
                global: "global".to_string(),
                order: vec![AddPart::GlobalFlag, AddPart::Command, AddPart::PackageName],
            },
            PackageManager::Bun => Add {
                command: "add".to_string(),
                global: "-g".to_string(),
                order: default_order,
            },
        };

        add.list(&args)
    }
}

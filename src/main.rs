mod package_managers;

use clap::{Parser, Subcommand};

use crate::package_managers::package_manager::{ExecError, PackageManager};
use package_managers::is_manager::get_package_manager;

use package_managers::exec::add::AddArgs;
use package_managers::exec::install::InstallArgs;

use std::process;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[clap(
        long,
        value_enum,
        help = "force a specifc package manager",
        aliases = &["package", "manager", "pm"]
    )]
    package_manager: Option<PackageManager>,

    #[command(subcommand)]
    cmd: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    ShowCurrent,
    Add {
        #[clap(help = "The name of the package to install")]
        package_name: String,

        #[clap(
            long,
            short,
            help = "install a package globally",
            aliases = &["glob", "gl", "globally"]
        )]
        global: bool,
    },
    Install,
}

fn main() {
    let cli = Args::parse();

    let package_manager = match cli.package_manager.or(get_package_manager()) {
        Some(pm) => pm,
        None => {
            eprintln!("Please specify a supported package manager");
            process::exit(1);
        }
    };

    let argument_list = match cli.cmd {
        Commands::ShowCurrent => {
            println!("{}", package_manager);
            return ();
        }
        Commands::Add {
            package_name,
            global,
        } => package_manager.add(AddArgs {
            package_name,
            global,
        }),
        Commands::Install => package_manager.install(InstallArgs {}),
    };

    let status = package_manager.execute(&argument_list);
    match status {
        Err(ExecError::NotStarted) => {
            eprintln!("Could not start process");
            process::exit(1)
        }
        _ => (),
    };
}
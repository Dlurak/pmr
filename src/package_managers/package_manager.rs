use serde::Serialize;
use std::fmt::{Display, Formatter};
use std::process::Command;

#[derive(Debug, Clone, Copy, clap::ValueEnum, Serialize)]
pub enum PackageManager {
    Npm,
    Yarn,
    Pnpm,
    Bun,
}

impl Display for PackageManager {
    fn fmt(&self, f: &mut Formatter<'_>) -> Result<(), std::fmt::Error> {
        let value = match self {
            PackageManager::Npm => "npm",
            PackageManager::Yarn => "yarn",
            PackageManager::Pnpm => "pnpm",
            PackageManager::Bun => "bun",
        };
        write!(f, "{}", value)
    }
}

pub trait Parse<T> {
    fn parse(str: &str) -> Result<T, ()>
    where
        Self: Sized;
}

impl Parse<PackageManager> for PackageManager {
    fn parse(str: &str) -> Result<PackageManager, ()> {
        match str.to_lowercase().as_str() {
            "npm" => Ok(PackageManager::Npm),
            "yarn" => Ok(PackageManager::Yarn),
            "pnpm" => Ok(PackageManager::Pnpm),
            "bun" => Ok(PackageManager::Bun),
            _ => Err(()),
        }
    }
}

#[derive(Debug)]
pub enum ExecError {
    NotStarted,
    Unsuccessfull,
}

impl PackageManager {
    pub fn execute(&self, args: &[String]) -> Result<i32, ExecError> {
        println!(" $ {} {}", self, args.join(" "));

        let output = Command::new(format!("{}", self)).args(args).status();

        match output {
            Ok(exit) => {
                if !exit.success() {
                    return Err(ExecError::Unsuccessfull);
                }
                let status = exit.code().unwrap_or(1);
                Ok(status)
            }
            Err(_) => Err(ExecError::NotStarted),
        }
    }
}

module package_manager

import os

pub struct PackageManager {
	manager      PackageManagers
	base_command string
}

pub fn PackageManager.new(manager_name string) PackageManager {
	manager_enum := get_manager_enum(manager_name) or {
		eprintln('Specify a supported package manager.')
		exit(1)
	}

	return PackageManager{manager_enum, manager_name}
}

pub fn (pm PackageManager) str() string {
	return pm.manager.str()
}

fn (pm PackageManager) execute(args []string) {
	os.execvp(pm.base_command, args) or { eprintln('Could not execute command') }
}

// add Add/install a new package.
// This does not work yet!
pub fn (pm PackageManager) add(args []string) {
	serialized_args := match pm.manager {
		.npm { ['install'] }
		.yarn { ['install'] }
		.pnpm { ['install'] }
		.bun { ['install'] }
	}

	pm.execute(serialized_args)
}

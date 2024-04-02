module package_manager

import os
import general
import package_manager.parts

pub struct PackageManager {
	manager      general.PackageManagers
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

pub fn (pm PackageManager) add(args parts.AddArgs) {
	argument_list := parts.Add.new(pm.manager, args.package_name).list()
	pm.execute(argument_list)
}

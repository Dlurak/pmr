module package_manager

import os
import arrays

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

pub fn (pm PackageManager) add(args []string) {
	serialized_arg := match pm.manager {
		.npm { 'install' }
		.yarn { 'add' }
		.pnpm { 'add' }
		.bun { 'add' }
	}

	pm.execute(arrays.append([serialized_arg], args))
}

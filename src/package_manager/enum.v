module package_manager

import is_manager
import general
import os
import maps

// get_manager_name Get the name of the package manager as a string.
// To do this the files in the cwd are beeing used.
// In the future I want to make this recursive: scan the cwd, go to the parent, scan... until root or an permissions error is hit
pub fn get_manager_name() !string {
	cwd := os.getwd()
	files := os.ls(cwd) or {
		eprintln('Permissions denied to read directory')
		exit(1)
	}

	managers := {
		'npm':  is_manager.is_npm(files)
		'yarn': is_manager.is_yarn(files)
		'pnpm': is_manager.is_pnpm(files)
		'bun':  is_manager.is_bun(files)
	}

	applied_managers := maps.filter(managers, fn (k string, v bool) bool {
		return v
	})

	applied_managers_amount := applied_managers.len

	if applied_managers_amount < 1 {
		return error('PMR supports npm, yarn, pnpm and bun, but no package manager has been detected.')
	} else if applied_managers_amount > 1 {
		return error('PMR supports npm, yarn, pnpm and bun, but multiple of these have been detected.')
	}

	return applied_managers.keys()[0]
}

pub fn get_manager_enum(manager_name string) !general.PackageManagers {
	return match manager_name {
		'npm' { .npm }
		'yarn' { .yarn }
		'pnpm' { .pnpm }
		'bun' { .bun }
		else { error('Unsupported package manager name') }
	}
}

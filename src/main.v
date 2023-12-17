module main

import os
import is_manager
import maps

fn main() {
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
		eprintln('PMR supports npm, yarn, pnpm and bun, but no package manager has been detected.')
		exit(1)
	} else if applied_managers_amount > 1 {
		eprintln('PMR supports npm, yarn, pnpm and bun, but multiple of these have been detected.')
		exit(1)
	}

	manager := applied_managers.keys()[0]
	println(manager)
}

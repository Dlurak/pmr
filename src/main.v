module main

import package_manager
import flag
import os

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('pmr')
	fp.version('v0.0.1')
	fp.description('PMR - Your unified package manager solution')
	fp.skip_executable()

	default_manager_name := package_manager.get_manager_name() or { 'default' }

	manager_name := fp.string('package-manager', 0, default_manager_name, 'Specify a package manager to use, defaults to the currently used one.')

	help := fp.bool('help', `h`, false, 'Show the help')
	show_current_manager := fp.bool('show-current', 0, false, "See which package manager is beeing used, if you don'nt specify one it will be the detected one")

	if help {
		println(fp.usage())
		exit(0)
	}

	manager := package_manager.PackageManager.new(manager_name)

	if show_current_manager {
		println(manager.str())
	}
}

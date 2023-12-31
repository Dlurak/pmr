module main

import package_manager
import os
import cli

fn main() {
	default_manager := package_manager.get_manager_name() or { '' }

	mut app := cli.Command{
		name: 'pmr'
		description: 'PMR is way to simplify the work with js package managers'
		commands: [
			cli.Command{
				name: 'show-current'
				description: 'Output the currently active package manager'
				execute: fn (cmd cli.Command) ! {
					print(get_manager_name(cmd))
					return
				}
			},
			cli.Command{
				name: 'add',
				description: 'Add a new package.',
				required_args: 1,
				execute: fn (cmd cli.Command) ! {
					pm := package_manager.PackageManager.new(get_manager_name(cmd))
					pm.add(cmd.args)
				}
			},
		]
		flags: [
			cli.Flag{
				flag: .string
				name: 'package-manager'
				abbrev: 'pm'
				global: true
				required: false
				default_value: [default_manager]
			},
		]
	}

	app.setup()
	app.parse(os.args)
}

fn get_manager_name(cmd cli.Command) string {
	return cmd.flags.get_string('package-manager') or {
		eprintln('Something went wrong')
		panic('Something went wrong')
	}
}

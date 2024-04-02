module main

import package_manager
import package_manager.parts
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
				name: 'add'
				description: 'Add a new package.'
				required_args: 1
				flags: [
					cli.Flag{
						flag: .bool
						name: 'global'
						abbrev: 'g'
						default_value: ['false']
					},
				]
				execute: fn (cmd cli.Command) ! {
					pm := package_manager.PackageManager.new(get_manager_name(cmd))
					pm.add(parts.AddArgs{
						package_name: cmd.args[0]
						global: cmd.flags.get_bool('global')!
					})
				}
			},
			cli.Command{
				name: 'install'
				description: 'Install dependencies'
				required_args: 0
				flags: [
					cli.Flag{
						flag: .bool
						name: 'lock'
						default_value: ['false']
					},
					cli.Flag{
						flag: .bool
						name: 'prod'
						default_value: ['false']
					},
				]
				execute: fn (cmd cli.Command) ! {
					pm := package_manager.PackageManager.new(get_manager_name(cmd))
					pm.install(parts.InstallArgs{
						frozen_lock: cmd.flags.get_bool('lock')!
						production: cmd.flags.get_bool('prod')!
					})
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

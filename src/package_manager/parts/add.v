module parts

import general

pub struct AddArgs {
	global bool
pub:
	package_name string
}

enum AddParts {
	command
	global
	name
}

pub struct Add {
	command      string
	global_flag  string
	order        []AddParts
	package_name string
}

pub fn Add.new(manager general.PackageManagers, name string) Add {
	return match manager {
		.npm {
			Add{
				command: 'install'
				global_flag: '-g'
				order: [.command, .global, .name]
				package_name: name
			}
		}
		.yarn {
			Add{
				command: 'install'
				global_flag: 'global'
				order: [.global, .command, .name]
				package_name: name
			}
		}
		.pnpm {
			Add{
				command: 'add'
				global_flag: '-g'
				order: [.command, .global, .name]
				package_name: name
			}
		}
		.bun {
			Add{
				command: 'add'
				global_flag: '-g'
				order: [.command, .global, .name]
				package_name: name
			}
		}
	}
}

pub fn (add Add) list(args AddArgs) []string {
	return add.order.map(fn [add, args] (part AddParts) string {
		return match part {
			.command {
				add.command
			}
			.global {
				if args.global { add.global_flag } else { '' }
			}
			.name {
				add.package_name
			}
		}
	})
}

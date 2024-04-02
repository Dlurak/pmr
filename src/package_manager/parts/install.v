module parts

import general

pub struct InstallArgs {
	frozen_lock bool
	production  bool
}

enum InstallPart {
	command
	frozen_lock
	prod
}

struct Install {
	command          string
	frozen_lock_flag string
	production_flag  string
	order            []InstallPart
}

pub fn Install.new(manager general.PackageManagers) Install {
	return match manager {
		.npm {
			Install{
				command: 'install'
				frozen_lock_flag: '--frozen-lockfile'
				production_flag: '--only=prod'
				order: [.command, .prod, .frozen_lock]
			}
		}
		.yarn {
			Install{
				command: 'install'
				frozen_lock_flag: '--frozen-lockfile'
				production_flag: '--production'
				order: [.command, .prod, .frozen_lock]
			}
		}
		.pnpm {
			Install{
				command: 'install'
				frozen_lock_flag: '--frozen-lockfile'
				production_flag: '--prod'
				order: [.command, .prod, .frozen_lock]
			}
		}
		.bun {
			Install{
				command: 'install'
				frozen_lock_flag: '--frozen-lockfile'
				production_flag: '--production'
				order: [.command, .frozen_lock, .prod]
			}
		}
	}
}

pub fn (install Install) list(args InstallArgs) []string {
	return install.order.map(fn [install, args] (part InstallPart) string {
		return match part {
			.command {
				install.command
			}
			.frozen_lock {
				if args.frozen_lock { install.frozen_lock_flag } else { '' }
			}
			.prod {
				if args.production { install.production_flag } else { '' }
			}
		}
	})
}

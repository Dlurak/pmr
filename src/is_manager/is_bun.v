module is_manager

pub fn is_bun(args []string) bool {
	return args.any(it == 'bun.lockb')
}


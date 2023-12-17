module is_manager

pub fn is_pnpm(args []string) bool {
	return args.any(it == 'pnpm-lock.yaml')
}

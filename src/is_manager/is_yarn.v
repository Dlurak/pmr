module is_manager

pub fn is_yarn(args []string) bool {
	return args.any(it == 'yarn.lock')
}

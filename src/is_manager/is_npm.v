module is_manager

pub fn is_npm(args []string) bool {
	return args.any(it == 'package-lock.json')
}

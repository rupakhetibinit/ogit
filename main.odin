package main

import "core:fmt"
import "core:io"
import "core:os"

main :: proc() {
	args := os.args
	args = args[1:]
	switch args[0] {
	case "init":
		init(args[1])
	case "cat-file":
		cat_file(args[1])
	case "check-ignore":
	// cmd_check_ignore(args)
	case "checkout":
	// cmd_checkout(args)
	case "commit":
	// cmd_commit(args)
	case "hash-object":
	// cmd_hash_object(args)
	case "log":
	// cmd_log(args)
	case "ls-files":
	// cmd_ls_files(args)
	case "ls-tree":
	// cmd_ls_tree(args)
	case "rev-parse":
	// cmd_rev_parse(args)
	case "rm":
	// cmd_rm(args)
	case "show-ref":
	// cmd_show_ref(args)
	case "status":
	// cmd_status(args)
	case "tag":
	// cmd_tag(args)
	case:
		fmt.println("Bad command.")
	}
}


init :: proc(location_name: string) {
	if (location_name == ".") {
		os.change_directory("test")
		os.make_directory(".git")
		fmt.printfln(
			"Successfully initialized git repository at current location %v",
			location_name,
		)
	}
}

cat_file :: proc(file: string) {
	data, ok := os.read_entire_file_from_filename(file)
	if (!ok) {
		fmt.println("sucks")
	}
	fmt.println(string(data))
}

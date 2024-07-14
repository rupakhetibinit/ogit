package main

import sha "core:crypto/hash"
import "core:encoding/hex"
import "core:fmt"
import "core:io"
import "core:os"
import "core:strings"

main :: proc() {
	args := os.args
	// skip the first arg because it's the path of the file
	args = args[1:]
	switch args[0] {
	case "init":
		init()
	case "cat-file":
	// cat_file(args[1])
	case "check-ignore":
	// cmd_check_ignore(args)
	case "checkout":
	// cmd_checkout(args)
	case "commit":
	// cmd_commit(args)
	case "hash-object":
		cmd_hash_object(args[1])
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


init :: proc() {
	os.change_directory("test")
	os.make_directory(".ogit")
	os.change_directory(".ogit")
	os.make_directory("objects")
	fmt.printfln("Successfully initialized git repository at current location")
}

cmd_hash_object :: proc(file_name: string) {
	path := ".ogit/objects"
	os.change_directory("test")

	data, ok := os.read_entire_file_from_filename(file_name)
	if !ok {
		fmt.println("Failed to read file:", file_name)
		fmt.println("Current directory:", os.get_current_directory())
		os.exit(1)
	}

	hash := sha.hash(sha.Algorithm.SHA256, data)
	hash_str := hex.encode(hash)

	final_path := fmt.aprintf("%s/%s", path, hash_str)
	defer delete(final_path)
	success := os.write_entire_file(final_path, data)

	if (!success) {
		fmt.println("failed to save to git objects")
		os.exit(1)
	}

	defer os.exit(0)
}

package main

TEST_DIRECTORY :: "test"
GIT_OJBECTS_DIR :: ".ogit/objects"


import "core:bytes"
import sha "core:crypto/hash"
import "core:encoding/hex"
import "core:fmt"
import "core:io"
import "core:mem"
import "core:os"
import "core:strings"

main :: proc() {
	args := os.args
	// skip the first arg because it's the path of the file
	args = args[1:]
	// fmt.println(args)
	switch args[0] {
	case "init":
		init()
	case "cat-file":
		cmd_cat_file(args[1])
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
	fmt.printfln("Successfully initialized ogit repository at current location")
}

cmd_hash_object :: proc(file_name: string, type := "blob") {
	path := ".ogit/objects"
	defer delete(path)
	os.change_directory("test")

	data, ok := os.read_entire_file_from_filename(file_name)
	if !ok {
		fmt.println("Failed to read file:", file_name)
		fmt.println("Current directory:", os.get_current_directory())
		os.exit(1)
	}
	defer delete(data)

	data = bytes.concatenate([][]byte{transmute([]byte)type, []byte{0}, data})

	hash_buffer: [32]byte
	sha.hash_bytes_to_buffer(sha.Algorithm.SHA256, data, hash_buffer[:])
	hash := hex.encode(hash_buffer[:])
	defer delete(hash)

	path = strings.concatenate([]string{path, "/", string(hash)}) or_else unreachable()

	success := os.write_entire_file(path, data)

	if (!success) {
		fmt.println("failed to save to git objects")
		os.exit(1)
	}

	fmt.println(string(hash))
	defer os.exit(0)

}

cmd_cat_file :: proc(hash_str: string) {
	hash := get_object(string(hash_str))
	defer delete(hash)

	result := strings.split(string(hash), "\x00") or_else unreachable()
	defer delete(result)

	fmt.println((result[1]))
}

get_object :: proc(hash: string, check: bool = false) -> []u8 {
	os.change_directory(TEST_DIRECTORY)

	path := fmt.aprintf("%s/%s", GIT_OJBECTS_DIR, hash)
	defer {
		delete(path)
	}

	data, ok := os.read_entire_file(path)

	// fmt.aprintln()

	if (!ok) {
		fmt.println("\nFailed to cat-file")
		os.exit(1)
	}
	return data
}

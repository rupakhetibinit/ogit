package main
import "core:c"
import "core:fmt"
foreign import asm_file "test.asm"

foreign asm_file {
	add_numbers :: proc "c" (a: i64, b: i64) -> i64 ---
}

main :: proc() {
	x := add_numbers(1, 2)
	fmt.println(x)
}

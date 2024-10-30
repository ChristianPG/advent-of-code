package day_01

import "core:fmt"
import "core:os"

main :: proc() {
	shouldUseDemoInputArgument := len(os.args) > 1 && os.args[1] == "demo"
	inputFileName := shouldUseDemoInputArgument ? "demo-input.txt" : "input.txt"

	fileData, success := os.read_entire_file(inputFileName)
	fmt.println("Reading file: ", inputFileName)
	if (!success) {
		fmt.println("Failed to read file:", inputFileName)
		return
	}
	defer delete(fileData, context.allocator)

	fileContent := string(fileData)
	fmt.println("File content:", string(fileData))

	finalAccumulator := 0
	for character, index in fileContent {
		if character == '(' {
			finalAccumulator += 1
		} else if character == ')' {
			finalAccumulator -= 1
		}
		if finalAccumulator == -1 {
			fmt.println("Basement reached at position:", index + 1)
		}
	}

	fmt.println("Final accumulator:", finalAccumulator)
}

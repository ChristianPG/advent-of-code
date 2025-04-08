package day_01

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	should_use_demo_input_argument := len(os.args) > 1 && os.args[1] == "demo"
	input_file_name := should_use_demo_input_argument ? "demo-input.txt" : "input.txt"

	file_data, success := os.read_entire_file(input_file_name)
	fmt.println("Reading file: ", input_file_name)
	if (!success) {
		fmt.println("Failed to read file:", input_file_name)
		return
	}
	defer delete(file_data, context.allocator)

	file_content := string(file_data)
	fmt.println("File content:", string(file_data))

	accumulated := 0
	lastConditionalWasDont := false

	for line in strings.split_lines_iterator(&file_content) {
		dont_divided_instructions := strings.split(line, "don't()")
		fmt.println("Dont divided instructions:", dont_divided_instructions)

		enabled_instructions: [dynamic]string
		defer delete(enabled_instructions)

		do_divided_instructions := strings.split(dont_divided_instructions[0], "do()")

		append(
			&enabled_instructions,
			..do_divided_instructions[(lastConditionalWasDont && len(do_divided_instructions) > 0 ? 1 : 0):],
		)
		if len(do_divided_instructions) > 1 || dont_divided_instructions[0] == "do()" {
			lastConditionalWasDont = false
		}

		for dont_divided_instruction in dont_divided_instructions[1:] {
			do_divided_instructions := strings.split(dont_divided_instruction, "do()")

			if len(do_divided_instructions) > 1 {
				lastConditionalWasDont = false
				append(&enabled_instructions, ..do_divided_instructions[1:])
			} else {
				lastConditionalWasDont = true
			}
		}

		for enabled_instruction in enabled_instructions {
			mul_arr := strings.split(enabled_instruction, "mul")
			for mul_instruction in mul_arr {
				if len(mul_instruction) > 1 && mul_instruction[0] == '(' {
					parsed_mul_instruction := mul_instruction[1:]
					parsed_mul_instruction = strings.split(parsed_mul_instruction, ")")[0]
					fmt.println("Parsed mul instruction:", parsed_mul_instruction)

					mul_parameters := strings.split(parsed_mul_instruction, ",")

					if len(mul_parameters) != 2 {
						fmt.println("Invalid mul instruction:", mul_instruction)
						continue
					}

					first_number, is_first_valid := strconv.parse_int(mul_parameters[0])
					second_number, is_second_valid := strconv.parse_int(mul_parameters[1])

					if !is_first_valid || !is_second_valid {
						fmt.println("Invalid numbers in mul instruction:", mul_instruction)
						continue
					}

					accumulated += first_number * second_number
				} else {
					continue
				}
			}
		}
	}
	fmt.println("Accumulated:", accumulated)
}

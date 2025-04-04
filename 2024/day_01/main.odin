package day_01

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

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

	leftList: [dynamic]int
	rightList: [dynamic]int

	for line in strings.split_lines(fileContent) {
		if line == "" {
			continue
		}
		numbers := strings.split(line, "   ")
		if len(numbers) != 2 {
			fmt.println("Invalid line format:", line)
			continue
		}
		num1, _ := strconv.parse_int(numbers[0])
		num2, _ := strconv.parse_int(numbers[1])
		fmt.println("Parsed numbers:", num1, num2)

		append(&leftList, num1)
		append(&rightList, num2)
	}

	sort_and_modify_int_array(leftList)
	sort_and_modify_int_array(rightList)

	accumulatedDistance := 0

	for i := 0; i < len(leftList); i += 1 {
		accumulatedDistance += abs(leftList[i] - rightList[i])
	}

	fmt.println("Accumulated distance:", accumulatedDistance)

	fmt.println("Calculated similarity:", calculate_similarity(leftList, rightList))
}

sort_and_modify_int_array :: proc(array: [dynamic]int) {
	// Sort the array in ascending order
	for i := 0; i < len(array); i += 1 {
		for j := i + 1; j < len(array); j += 1 {
			if array[i] > array[j] {
				temp := array[i]
				array[i] = array[j]
				array[j] = temp
			}
		}
	}
	fmt.println("Sorted array:", array)
}

calculate_similarity :: proc(
	leftList: [dynamic]int,
	rightList: [dynamic]int,
) -> (
	similarity: int,
) {
	similarity = 0
	for i := 0; i < len(leftList); i += 1 {
		occurrence_count := 0
		for j := 0; j < len(rightList); j += 1 {
			occurrence_count += (leftList[i] == rightList[j]) ? 1 : 0
		}
		similarity += leftList[i] * occurrence_count
	}
	return similarity
}

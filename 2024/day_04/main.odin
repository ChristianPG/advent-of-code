package day_04

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// Types
Vec2i :: [2]int

// Global Constants
UP_DIRECTION :: Vec2i{0, -1}
UP_RIGHT_DIRECTION :: Vec2i{1, -1}
RIGHT_DIRECTION :: Vec2i{1, 0}
RIGHT_DOWN_DIRECTION :: Vec2i{1, 1}
DOWN_DIRECTION :: Vec2i{0, 1}
DOWN_LEFT_DIRECTION :: Vec2i{-1, 1}
LEFT_DIRECTION :: Vec2i{-1, 0}
LEFT_UP_DIRECTION :: Vec2i{-1, -1}
SEARCH_WORD :: [4]rune{'X', 'M', 'A', 'S'}

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

	word_soup_matrix: [dynamic][dynamic]rune
	word_count := 0

	fmt.println("Search word:", SEARCH_WORD)
	line_index := 0
	for line in strings.split_lines_iterator(&file_content) {
		line_letters := [dynamic]rune{}
		for letter, letter_index in line {
			append(&line_letters, letter)
		}
		append(&word_soup_matrix, line_letters)
	}

	for row, row_index in word_soup_matrix {
		for letter, letter_index in row {
			if letter == SEARCH_WORD[0] {
				letter_position := Vec2i{letter_index, row_index}
				fmt.println("Found first letter at position:", letter_position)
				if (verify_next_letter(
						   word_soup_matrix,
						   UP_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   UP_RIGHT_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   RIGHT_DOWN_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   DOWN_LEFT_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   LEFT_UP_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   LEFT_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   DOWN_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
				if (verify_next_letter(
						   word_soup_matrix,
						   RIGHT_DIRECTION,
						   letter_position,
						   0,
						   SEARCH_WORD,
					   )) {
					word_count += 1
				}
			}
		}
	}
	verify_next_letter(word_soup_matrix, RIGHT_DIRECTION, Vec2i{5, 0}, 0, SEARCH_WORD)

	fmt.println("Word count for XMAS:", word_count)

	/* Part 2 */
	x_shape_count := 0

	for row, row_index in word_soup_matrix {
		if row_index == 0 || row_index == len(word_soup_matrix) - 1 {
			continue
		}
		for letter, letter_index in row {
			if letter_index == 0 || letter_index == len(row) - 1 {
				continue
			}
			if letter == 'A' {
				letter_position := Vec2i{letter_index, row_index}
				fmt.println("Found 'A' letter at position:", letter_position)
				if (verify_x_shape_around(word_soup_matrix, letter_position)) {
					x_shape_count += 1
				}
			}
		}
	}

	fmt.println("X-Shape count for MAS:", x_shape_count)
}

verify_next_letter :: proc(
	word_soup_matrix: [dynamic][dynamic]rune,
	direction: Vec2i,
	current_letter_position: Vec2i,
	current_letter_index: int,
	search_word: [4]rune,
) -> bool {
	if (((direction == UP_DIRECTION ||
				   direction == UP_RIGHT_DIRECTION ||
				   direction == LEFT_UP_DIRECTION) &&
			   current_letter_position[1] < 3 - current_letter_index) ||
		   ((direction == RIGHT_DIRECTION ||
					   direction == RIGHT_DOWN_DIRECTION ||
					   direction == UP_RIGHT_DIRECTION) &&
				   current_letter_position[0] >
					   len(word_soup_matrix[current_letter_position[1]]) -
						   4 +
						   current_letter_index) ||
		   ((direction == DOWN_DIRECTION ||
					   direction == DOWN_LEFT_DIRECTION ||
					   direction == RIGHT_DOWN_DIRECTION) &&
				   current_letter_position[1] >
					   len(word_soup_matrix) - 4 + current_letter_index) ||
		   ((direction == LEFT_DIRECTION ||
					   direction == LEFT_UP_DIRECTION ||
					   direction == DOWN_LEFT_DIRECTION) &&
				   current_letter_position[0] < 3 - current_letter_index)) {
		return false
	}

	next_letter_position := current_letter_position + direction
	next_letter_index := current_letter_index + 1
	next_letter := search_word[next_letter_index]

	if word_soup_matrix[next_letter_position[1]][next_letter_position[0]] != next_letter {
		return false
	} else if next_letter_index == len(search_word) - 1 {
		fmt.println("Found word at position:", next_letter_position, "in direction:", direction)
		return true
	}

	return verify_next_letter(
		word_soup_matrix,
		direction,
		next_letter_position,
		next_letter_index,
		search_word,
	)
}

verify_x_shape_around :: proc(
	word_soup_matrix: [dynamic][dynamic]rune,
	middle_letter_position: Vec2i,
) -> bool {
	upper_left_letter :=
		word_soup_matrix[middle_letter_position[1] + LEFT_UP_DIRECTION[1]][middle_letter_position[0] + LEFT_UP_DIRECTION[0]]
	upper_right_letter :=
		word_soup_matrix[middle_letter_position[1] + UP_RIGHT_DIRECTION[1]][middle_letter_position[0] + UP_RIGHT_DIRECTION[0]]
	lower_left_letter :=
		word_soup_matrix[middle_letter_position[1] + DOWN_LEFT_DIRECTION[1]][middle_letter_position[0] + DOWN_LEFT_DIRECTION[0]]
	lower_right_letter :=
		word_soup_matrix[middle_letter_position[1] + RIGHT_DOWN_DIRECTION[1]][middle_letter_position[0] + RIGHT_DOWN_DIRECTION[0]]

	if ((upper_left_letter == 'M' && lower_right_letter == 'S') ||
		   (upper_left_letter == 'S' && lower_right_letter == 'M')) &&
	   ((upper_right_letter == 'M' && lower_left_letter == 'S') ||
			   (upper_right_letter == 'S' && lower_left_letter == 'M')) {
		return true
	} else {
		return false
	}
}

package day_05

import "core:crypto/legacy/md5"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// Types
Vec2i :: [2]int

// Global Constants
UP_DIRECTION :: Vec2i{0, -1}
DOWN_DIRECTION :: Vec2i{0, 1}
RIGHT_DIRECTION :: Vec2i{1, 0}
LEFT_DIRECTION :: Vec2i{-1, 0}
DIRECTIONS_MAP := map[rune]Vec2i {
	'^' = UP_DIRECTION,
	'v' = DOWN_DIRECTION,
	'>' = RIGHT_DIRECTION,
	'<' = LEFT_DIRECTION,
}

is_nice_word_part_1 :: proc(word: string) -> bool {
	vowels_count := 0
	has_repeated_letter := false
	prohibited_words: [4]string = {"ab", "cd", "pq", "xy"}

	for index := 0; index < len(word); index += 1 {
		for prohibited_word in prohibited_words {
			if strings.contains(word, prohibited_word) {
				return false
			}
		}

		character := word[index]
		if character == 'a' ||
		   character == 'e' ||
		   character == 'i' ||
		   character == 'o' ||
		   character == 'u' {
			vowels_count += 1
		}
		if !has_repeated_letter && index + 1 < len(word) && character == word[index + 1] {
			has_repeated_letter = true
		}
	}

	return vowels_count >= 3 && has_repeated_letter
}

is_nice_word_part_2 :: proc(word: string) -> bool {
	has_repeated_pair := false
	has_repeated_letter := false

	for index := 0; index < len(word); index += 1 {
		character := word[index]
		if index + 1 < len(word) {
			pair := string([]u8{character, word[index + 1]})
			if strings.count(word, pair) > 1 {
				has_repeated_pair = true
			}
		}
		if !has_repeated_letter && index + 2 < len(word) && character == word[index + 2] {
			has_repeated_letter = true
		}
		if has_repeated_pair && has_repeated_letter {
			return true
		}
	}

	return false
}

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

	number_of_nice_words := 0
	for line in strings.split_lines(fileContent) {
		fmt.println("Line:", line)
		is_nice := is_nice_word_part_2(line)

		if is_nice {
			fmt.println("Word is nice")
			number_of_nice_words += 1
		}
	}

	fmt.println("Number of nice words:", number_of_nice_words)
}

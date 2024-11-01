package day_03

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

	visited_houses := map[Vec2i]int {
		Vec2i{0, 0} = 1,
	}
	carrier_map := map[bool]Vec2i {
		true  = Vec2i{0, 0},
		false = Vec2i{0, 0},
	}
	is_santa_turn := true

	for character in fileContent {
		fmt.println("Character: ", character)
		fmt.println("DIRECTIONS_MAP[character]: ", DIRECTIONS_MAP[character])
		carrier_map[is_santa_turn] += DIRECTIONS_MAP[character]
		fmt.println("Current position", carrier_map[is_santa_turn])
		_, visited := visited_houses[carrier_map[is_santa_turn]]
		fmt.println("Visited: ", visited)
		if visited {
			visited_houses[carrier_map[is_santa_turn]] += 1
		} else {
			visited_houses[carrier_map[is_santa_turn]] = 1
		}
		is_santa_turn = !is_santa_turn
	}

	fmt.println("Number of unique houses visited:", len(visited_houses))
}

package day_02

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

	squareFeetOfWrappingPaper := 0
	feetOfRibbon := 0
	for line, index in strings.split_lines(fileContent) {
		characters := strings.split(line, "x")
		xDimension := strconv.atoi(characters[0])
		yDimension := strconv.atoi(characters[1])
		zDimension := strconv.atoi(characters[2])
		area1 := xDimension * yDimension
		area2 := yDimension * zDimension
		area3 := zDimension * xDimension
		lowestArea := area1

		if (area1 <= area2 && area1 <= area3) {
			lowestArea = area1
			feetOfRibbon += 2 * xDimension + 2 * yDimension
		} else if (area2 <= area1 && area2 <= area3) {
			lowestArea = area2
			feetOfRibbon += 2 * yDimension + 2 * zDimension
		} else {
			lowestArea = area3
			feetOfRibbon += 2 * zDimension + 2 * xDimension
		}

		squareFeetOfWrappingPaper += 2 * area1 + 2 * area2 + 2 * area3 + lowestArea
		feetOfRibbon += xDimension * yDimension * zDimension
	}

	fmt.println("square feet of wrapping paper:", squareFeetOfWrappingPaper)
	fmt.println("Feet of ribbon:", feetOfRibbon)
}

import Foundation

final class FillWithColor {
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        if row < 0
            || row >= image.count
            || column < 0
            || column > 50
            || column >= image[row].count {
            return image
        }

        var grid = image
        let oldColor = image[row][column]

        callBFS(&grid, row, column, oldColor, newColor)
        return grid
    }

    func callBFS(_ image: inout [[Int]], _ row: Int, _ column: Int, _ oldColor: Int, _ newColor: Int) {
        if row < 0
            || row >= image.count
            || column < 0
            || column >= image[row].count
            || image[row][column] != oldColor {
            return
        }
        image[row][column] = newColor
        callBFS(&image, row + 1, column, oldColor, newColor)
        callBFS(&image, row - 1, column, oldColor, newColor)
        callBFS(&image, row, column + 1, oldColor, newColor)
        callBFS(&image, row, column - 1, oldColor, newColor)
    }
}

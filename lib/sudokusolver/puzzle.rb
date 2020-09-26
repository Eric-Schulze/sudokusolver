# puzzle.rb

require_relative "position"

module SudokuSolver
    PuzzleRowValidation = Struct.new(:isValid?, :errorMsg, :rowArray)

    class Puzzle
        attr_accessor :grid

        def initialize()
            @grid = Array.new
        end

        def to_s
            puzzle_s = ""
            9.times do |i|
                9.times do |j|
                    if !@grid[i][j].nil? && @grid[i][j] > 0
                        puzzle_s += "#{@grid[i][j]} "
                    else
                        puzzle_s += "_ "
                    end
                end
                puzzle_s += "\n"
            end

            return puzzle_s
        end

        def self.validate_row(arr)
            errMsg = ""
            valid = true

            unless arr.length == 9
                valid = false
                errMsg = "Row must have 9 entries"
            end

            arr.each_with_index do |n, index|
                if n < 1 || n > 9
                    valid = false
                    errMsg = "Entry at position #{index + 1} must be within digits 1-9."
                    break
                end
            end

            return PuzzleRowValidation.new(valid, errMsg, arr)
        end

        def insert_row(index, row)
            @grid[index] = row
        end
    end
end

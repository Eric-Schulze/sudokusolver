# puzzle.rb

require_relative "solver"
require_relative "enums"

module SudokuSolver
    PuzzleRowValidation = Struct.new(:isValid?, :errorMsg, :rowArray)
    Position = Struct.new(:xpos, :ypos, :value, :possible_values)
    Group = Struct.new(:solved, :missing_digits, :type, :id)

    class Puzzle
        attr_accessor :grid, :currentNumberUnsolved, :currentNumberSolved

        def initialize()
            @grid = Array.new
            @currentNumberUnsolved = 0
            @currentNumberSolved = 0
        end

        def solution_options
            return [1, 2, 3, 4, 5, 6, 7, 8, 9]
        end

        def to_s
            puzzle_s = ""

            if @grid.length > 0
                9.times do |i|
                    9.times do |j|
                        entry = @grid[i][j].value
                        if !entry.nil? && Integer(entry) > 0
                            puzzle_s += "#{entry}  "
                        else
                            puzzle_s += "_  "
                        end

                        if j == 2 || j == 5
                            puzzle_s += "| "
                        end
                    end
                    puzzle_s += "\n"

                    if i == 2 || i == 5
                        puzzle_s += "------------------------------\n"
                    end
                end
            elsif 
                puzzle_s += "Puzzle is currently empty."
            end

            puzzle_s += "\n\n\n"
            puzzle_s += "Current Number of Unsolved Digits: #{@currentNumberUnsolved}\n"
            puzzle_s += "Current Number of Solved Digits: #{@currentNumberSolved}\n"

            return puzzle_s
        end

        def self.validate_row(arr)
            errMsg = ""
            valid = true

            unless arr.length == 9
                valid = false
                errMsg = "Row must have 9 entries"
            end

            intArr = []
            arr.each_with_index do |n, index|
                if index > 8
                    valid = false
                    errMsg = "Too many entries. Only 9 entries allowed per row."
                    break
                end

                digit = 0
                begin
                    unless n == "_"
                        digit = Integer(n)

                        if digit < 1 || digit > 9
                            valid = false
                            errMsg = "Entry at position #{index + 1} must be within digits 1-9."
                            break
                        end
                    end
                rescue 
                    valid = false
                    errMsg = "Entry at position #{index + 1} must be a digit or underscore."
                    break
                end
                
                intArr[index] = digit
            end

            return PuzzleRowValidation.new(valid, errMsg, intArr)
        end

        def insert_row(index, row)
            positions_row = []
            row.each_with_index do |n, index|
                positions_row[index] = Position.new(index, row, n)

                if positions_row[index].value > 0
                    @currentNumberSolved += 1
                elsif
                    @currentNumberUnsolved += 1
                end
            end

            @grid[index] = positions_row
        end

        def solve_puzzle
            solve = Solver.new(self)

            solve.start_solve

            self.to_s
        end

        def is_sovled?
            return @currentNumberUnsolved == 0 && @currentNumberSolved = 81
        end
    end
end

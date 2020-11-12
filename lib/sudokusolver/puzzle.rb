# puzzle.rb

require_relative "solver"
require_relative "enums"

module SudokuSolver
    PuzzleRowValidation = Struct.new(:isValid?, :errorMsg, :rowArray)
    Position = Struct.new(:xpos, :ypos, :value, :possible_values)
    Group = Struct.new(:group_type, :id, :missing_digits_arr, :position_ids_arr) do
        def solved?
            @solved
        end

        def solved=(value)
            @solved = value
        end
    end

    class Puzzle
        attr_accessor :currentNumberUnsolved, :currentNumberSolved
        attr_reader :grid, :bands, :stacks, :blocks

        def initialize()
            solver = Solver.new(self)

            create_blank_puzzle
        end

        def create_blank_puzzle 
            @grid = Hash.new

            @bands = create_new_group_arr(GroupType::BAND)
            @stacks = create_new_group_arr(GroupType::STACK)
            @blocks = create_new_group_arr(GroupType::BLOCK)

            1.upto(9) do |i|
                1.upto(9) do |j|
                    position = Position.new(i, j, 0, (1..9).to_a)

                    @grid[i.to_s + j.to_s] = position
                    @bands[i].position_ids_arr.push(position.object_id)
                    @stacks[j].position_ids_arr.push(position.object_id)
                    @blocks[get_block(i, j)].position_ids_arr.push(position.object_id)
                end
            end

            @currentNumberUnsolved = 81
            @currentNumberSolved = 0
        end

        def create_new_group_arr(group_type)
            arr = Hash.new
            
            1.upto(9) do |i|
                arr[i] = Group.new(group_type, i, (1..9).to_a, Array.new)
            end

            return arr
        end

        def get_block(x, y)
            return (((x - 1) / 3) * 3) + ((y - 1)/ 3) + 1
        end

        def solution_options
            return [1, 2, 3, 4, 5, 6, 7, 8, 9]
        end

        def to_s
            puzzle_s = ""

            if @grid.length > 0
                1.upto(9) do |i|
                    1.upto(9) do |j|
                        entry = @grid[i.to_s + j.to_s].value
                        if !entry.nil? && Integer(entry) > 0
                            puzzle_s += "#{entry}  "
                        else
                            puzzle_s += "_  "
                        end

                        if j == 3 || j == 6
                            puzzle_s += "| "
                        end
                    end
                    puzzle_s += "\n"

                    if i == 3 || i == 6
                        puzzle_s += "------------------------------\n"
                    end
                end
            elsif 
                puzzle_s += "Puzzle is currently empty."
            end

            puzzle_s += "\n\n"
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

        def insert_row(band_index, row)
            #puts @grid.to_s
            row_items = 0
            row.each_with_index do |n, stack_index|
                #puts "Value: #{n}; Column: #{stack_index}"
                pos = @grid[band_index.to_s + (stack_index + 1).to_s]

                if n > 0
                    row_items += 1

                    solver.solve_position(pos.object_id, n)
                else
                    pos.value = n
                end
            end

            #puts "Unsolved: #{@currentNumberUnsolved}"
            #puts "Solved: #{@currentNumberSolved}"

            if row_items == 9
                @bands.select{ |key, band| 
                    band.group_type == GroupType::BAND && band.id == band_index
                }.first()[1].solved= true
            end
        end

        def self.set_position_possibilities(group)

        end

        def solve_puzzle

            puts "Puzzle Before Solving:\n#{self.to_s}\n\n"

            solver.start_solve

            puts "-----------------------------------\n\n"
            puts "Solved Puzzle:\n#{self.to_s}\n"
        end

        def is_sovled?
            return @currentNumberUnsolved == 0 && @currentNumberSolved == 81
        end

        def puzzle_completed
            self.to_s

            puts "\n\nSolution Completed!"
        end
    end
end

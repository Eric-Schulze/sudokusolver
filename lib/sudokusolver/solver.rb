# solver.rb

require_relative "enums"

module SudokuSolver
    class Solver
        attr_accessor :puzzle

        def initialize(puzzle)
            self.puzzle = puzzle
        end

        def solution_options
            return [1, 2, 3, 4, 5, 6, 7, 8, 9]
        end

        def start_solve
            check_for_single_digits
        end

        def check_for_single_digits
            check_group_for_single_digits(get_missing_digits_in_bands)

            check_group_for_single_digits(get_missing_digits_in_stacks)

            check_group_for_single_digits(get_missing_digits_in_blocks)
        end

        def check_group_for_single_digits (get_missing_digits)
            digit_arr = get_missing_digits


        end

        def get_missing_digits_in_bands
            missing_digits = []

            9.times do |i|
                missing_digits[i] = get_missing_digits_from_group(@puzzle.grid[i])

                puts "Missing Digits in Band #{i + 1}: #{missing_digits[i]}"
            end

            return missing_digits
        end

        def get_missing_digits_in_stacks
            missing_digits = []

            9.times do |j|
                stack_positions = []
                9.times do |i|
                    stack_positions.push(@puzzle.grid[i][j])
                end

                missing_digits[j] = get_missing_digits_from_group(stack_positions)

                puts "Missing Digits in Stack #{j + 1}: #{missing_digits[j]}"
            end

            return missing_digits
        end

        def get_missing_digits_in_blocks
            missing_digits = []

            3.times do |i|
                3.times do |j|
                    stack_positions = []
                    3.times do |m|
                        3.times do |n|
                            stack_positions.push(@puzzle.grid[3 * i + n][3 * j + m])
                        end
                    end

                    missing_digits[3 * i + j] = get_missing_digits_from_group(stack_positions)

                    puts "Missing Digits in Block #{(3 * i + j) + 1}: #{missing_digits[3 * i + j]}"
                end
            end

            return missing_digits
        end

        def get_missing_digits_from_group(group_arr)
            digits = solution_options

            group_arr.each_with_index do |n, index|
                digits.delete(n.value)
            end

            return digits
        end

        def solve_position

        end

        def remove_position_posibilities

        end
    end
end
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
            #puts "Start Solve Start"

            check_for_single_digits

            #puts "Start Solve Complete"
        end

        def check_for_single_digits
            #puts "Check Single Digits Start"

            check_group_for_single_digits(@puzzle.bands)

            check_group_for_single_digits(@puzzle.stacks)

            check_group_for_single_digits(@puzzle.blocks)

            #puts "Check Single Digits Complete"
        end

        def check_group_for_single_digits (group_hash)
            #puts "Check Single Digits in Group #{Enums.enum_to_str(GroupType, group_hash[1].group_type)} Start"

            1.upto(9) do |index|
                group = group_hash[index]
                if group.solved?
                    next
                elsif group.missing_digits_arr.length == 0 && !group.solved?
                    group.solved= true
                elsif group.missing_digits_arr.length == 1
                    solve_group_with_single_missing_value(group)
                elsif group.missing_digits_arr.length >= 2
                    Puzzle.set_position_possibilities(group)
                end
            end

            #puts "Check Single Digits in Group #{Enums.enum_to_str(GroupType, group_hash[1].group_type)} Complete"
        end

        def solve_group_with_single_missing_value(group)
            puts "Solve Single Missing Value Start"

            unsolved_pos = group.position_ids_arr.select { |key, pos_id| 
                pos = ObjectSpace._id2ref(pos_id)
                pos.value == 0 && pos.possible_values.length == 1
            }
            if unsolved_pos.length == 1
                solve_position(group, unsolved_pos.first(), ObjectSpace._id2ref(unsolved_pos.first()).value)
            end

            puts "Solve Single Missing Value Complete"
        end

        def solve_position(group, position_id, value)
            puts "Solve Position Start"

            position = ObjectSpace._id2ref(pos_id)

            # Set value and possible values for position
            pos.value = n
            pos.possible_values = n.to_a

            # Set possible values array for all positions in the row
            1.upto(9) do |i|
                pos_in_row = @grid[band_index.to_s + i.to_s]
                if i == stack_index
                    pos_in_row.possible_values = n.to_a
                else
                    pos_in_row.possible_values.delete(n)
                end
            end

            # Remove value from each group's missing digits array
            @puzzle.bands.select { |key, band| 
                band.group_type == GroupType::BAND && band.id == band_index
            }.first()[1].missing_digits_arr.delete(n)

            @puzzle.stacks.select { |key, stack| 
                stack.group_type == GroupType::STACK && stack.id == (stack_index + 1)
            }.first()[1].missing_digits_arr.delete(n)

            @puzzle.blocks.select { |key, block| 
                block.group_type == GroupType::BLOCK && block.id == get_block(band_index, (stack_index + 1))
            }.first()[1].missing_digits_arr.delete(n)

            # rework to not need group
            if group.missing_digits_arr.length == 0
                group.solved= true
            end

            Puzzle.set_position_possibilities(group)
            # rework to not need group

            puzzle.currentNumberSolved += 1
            puzzle.currentNumberUnsolved -= 1

            puts "Solve Position Complete"
        end
    end
end

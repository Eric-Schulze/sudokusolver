# commands.rb

require_relative "puzzle"

module SudokuSolver
    module Commands
        extend self
        attr_reader :quit, :reset, :new, :print, :help, :solve

        def parse_commands (command)
            case command.downcase
            when "quit"
                quit
            when "reset"
                reset
            when "new"
                new_puzzle
            when "print"
                print_puzzle
            when "help"
                help
            when "edit"
                edit
            when "solve"
                #do solve here
            else
                ""
            end
        end

        def command_get
            puts "What would you like to do? Use \"help\" to get a list of commands"
            cmd = gets.chomp

            self.parse_commands cmd
        end

        def command_start
            @@puzzle = Puzzle.new

            command_get
        end

        def quit
            puts "Goodbye!"
            exit 0
        end

        def reset 
            @@puzzle = puzzle.new

            puts "The puzzle has been reset."

            command_get
        end

        def new_puzzle
            @@puzzle = Puzzle.new

            1.upto(10) do |i|
                loop do 
                    puts enter_row(i)
                    row_input = gets.chomp
                    break if !row_input.empty?

                    row_arr = parse_row(row_input)

                end
                
                @@puzzle.insert_row(row_arr)
            end

        end

        def print_puzzle
            puts @@puzzle.to_s
        end

        def help
            puts <<~HEREDOC
            'help'  = displays the current options
            'new'   = resets the puzzle and starts a new one
            'reset' = clears out the current puzzle entries 
            'edit'  = re-enter a specific row of the current puzzle
            'print' = display the current puzzle
            'solve' = solve the current puzzle and display the final outcome
            'quit'  = end the program
            HEREDOC

            command_get
        end

        def edit
            puts "Which row would you like to edit?"
            row_index = gets.chomp
            if !row_index.is_int?
                puts "Please enter a digit 1-9."
                edit
            elsif Float(row_index) > 9 || Float(row_index) < 1
                puts "Please enter a digit 1-9."
                edit
            else
                puts enter_row(row_index)
                row = gets.chomp

                row_arr = parse_row(row)

                @@puzzle.insert_row(row_arr)
            end
        end

        def enter_row (index)
            "Please enter the digits from row #{index}. Separate the digits by a space or tab. Use an underscore (_) to indicate an empty block."
        end

        def parse_row (row_string) 
            valid = true
            errMsg = ""

            row_string.slice!(/,/)
            arr = row_string.split(/\t|\s/)

            floatArr = []
            arr.each_with_index do |n, index|
                if !n.is_int?
                    errMsg = "Entry at position #{index + 1} must be a digit."
                    valid = false
                    break
                end

                floatArr[index] = Float(n)
            end

            return Puzzle.validate_row arr
        end

        class String
            def is_int?
                true if Float(self) rescue false
            end
        end
    end
end
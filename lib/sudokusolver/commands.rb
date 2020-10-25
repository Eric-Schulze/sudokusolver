# commands.rb

require_relative "puzzle"

module SudokuSolver
    Command = Struct.new(:command, :args)

    module Commands
        extend self
        attr_reader :quit, :reset, :new, :print, :help, :solve

        def parse_commands (command)
            command_parsed = command_split(command)

            case command_parsed.command.downcase.strip
            when "quit"
                quit
            when "reset"
                reset
            when "new"
                new_puzzle(command_parsed.args)
            when "print"
                print_puzzle
            when "help"
                help
            when "edit"
                edit
            when "solve"
                @@puzzle.solve_puzzle
            else
                puts "Invalid Command"
                command_get
            end
        end

        def command_split (command)
            split = command.index(/\s/)
            unless split.nil?
                command_text = command[0..split]

                command_args = command[(split + 1)..-1].split(/\s-/) 

                command_hashes = Hash.new
                command_args.each do |n|
                    n.slice!(/-/)
                    puts n

                    arg_kvp = n.split(/\s/)
                    command_hashes[arg_kvp[0]] = arg_kvp[1]
                end
            else
                command_text = command
                command_hashes = Hash.new
            end

=begin      
            puts "Command Text: #{command_text}"
            puts "Command Args:"
            command_hashes.each do |key, value|
                puts "#{key}: #{value}"
            end
=end

            return Command.new(command_text, command_hashes)
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
            @@puzzle = Puzzle.new

            puts "The puzzle has been reset."

            command_get
        end

        def new_puzzle (args)
            @@puzzle = Puzzle.new

            if args.has_key?("path")
                line_count = 0
                IO.foreach(args["path"]){ |line|
                    line_count += 1
                    if line_count > 9
                        break
                    end

                    puts line

                    row_validation = parse_row(line)

                    if row_validation.isValid?
                        @@puzzle.insert_row(line_count - 1, row_validation.rowArray)
                    else
                        puts "There was an error in line #{line_count}"
                        puts row_validation.errorMsg
                        break
                    end
                }
            else
                1.upto(9) do |i|
                    loop do 
                        puts enter_row(i)
                        row_input = gets.chomp
                        break if row_input.empty?

                        row_validation = parse_row(row_input)

                        if row_validation.isValid?
                            @@puzzle.insert_row(i, row_validation.rowArray)
                            break
                        else
                            puts row_validation.errorMsg
                        end
                    end
                end
            end

            command_get
        end

        def print_puzzle
            puts @@puzzle.to_s

            command_get
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

            begin
                row_int = Integer(row_index)

                if row_int > 9 || row_int < 1
                    puts "Please enter a digit 1-9."
                    edit
                else
                    puts enter_row(row_int)
                    row = gets.chomp
    
                    row_validation = parse_row(row)

                    if row_validation.isValid?
                        @@puzzle.insert_row(row_int - 1, row_validation.rowArray)
                    else
                        puts row_validation.errorMsg
                        edit
                    end
                end
            rescue
                puts "Please enter a digit 1-9."
                edit
            end

            command_get
        end

        def enter_row (index)
            "Please enter the digits from row #{index}. Separate the digits by a space or tab. Use an underscore (_) to indicate an empty block."
        end

        def parse_row (row_string) 
            row_string.slice!(/,/)
            arr = row_string.split(/\t|\s/)

            return Puzzle.validate_row arr
        end

        class String
            def is_int?
                true if Float(self) rescue false
            end
        end
    end
end
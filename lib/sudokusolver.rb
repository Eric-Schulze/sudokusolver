# sudokusolver.rb

require_relative "sudokusolver/commands.rb"

module SudokuSolver
    welcome = 'Welcome to the Sudoku Solver!'

    puts welcome

    Commands.command_start
end
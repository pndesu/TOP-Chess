require_relative 'square.rb'

class Board
    attr_accessor :board, :king_position
    @@board = []
    
    def self.board
        @@board
    end

    def initialize
        for i in 0..7
            row = []
            for j in 0..7
                row << Square.new(color: 'white', position: [i,j]) if i.odd? && j.odd?
                row << Square.new(color: 'dark', position: [i,j]) if i.odd? && j.even?
                row << Square.new(color: 'white', position: [i,j]) if i.even? && j.even?
                row << Square.new(color: 'dark', position: [i,j]) if i.even? && j.odd?
            end
            @@board << row
        end
        assign_notation
    end

    def update_board(board)
        @@board = board
    end
    
    def display_board(board = @@board)
        puts "   a  b  c  d  e  f  g  h"
        board.each_with_index do |row, index|
            print "#{(index - 8).abs} "
            row.each do |square|
                print square.display_square
            end
            print " #{(index - 8).abs}"
            print "\n"
        end
        puts "   a  b  c  d  e  f  g  h"
    end

    def assign_notation(board = @@board)
        ['8','7','6','5','4','3','2','1'].each_with_index do |r_value, r_index|
            ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].each_with_index do |c_value, c_index|
                board[r_index][c_index].notation = c_value + r_value
            end
        end
    end
end
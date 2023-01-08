require_relative 'square.rb'

class Board
    attr_accessor :board
    @@board = []
    def self.board
        @@board
    end
    def reset_board
        for i in 0..7
            row = []
            for j in 0..7
                row << Square.new('white', ' ') if i.odd? && j.odd? #Position only used here
                row << Square.new('dark', ' ') if i.odd? && j.even?
                row << Square.new('white', ' ') if i.even? && j.even?
                row << Square.new('dark', ' ') if i.even? && j.odd?
            end
            @@board << row
        end
    end
    
    def display_board(board = @@board)
        board.each do |row|
            row.each do |square|
                print square.display_square
            end
            print "\n"
        end
    end
end
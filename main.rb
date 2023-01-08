require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'

class Game
    include SquareAction
    def play
        board = Board.new
        white = White.new
        black = Black.new
        square = white.get_square('a2')
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('a4')))
            white.move_to_new_square(square.position, 'a4')
        end
        white.move_to_new_square('b1', 'c3')
        board.display_board
    end
end
Game.new.play

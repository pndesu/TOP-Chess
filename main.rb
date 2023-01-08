require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'

class Game
    include SquareAction
    def play
        board = Board.new
        board.reset_board
        white = White.new
        black = Black.new
        square = white.get_square('a3')
        if check_valid_square?(square, 'white')
            white.move_to_new_square(square.position, 'a4')
        end
        white.move_to_new_square('b1', 'c3')
        board.display_board
    end
end
Game.new.play

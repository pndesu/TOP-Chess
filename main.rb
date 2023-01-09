require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'

class Game
    include PieceAction, SquareAction
    def play
        board = Board.new
        white = White.new
        black = Black.new
        square = white.get_square('a2')
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('a4')))
            white.move_to_new_square(square.notation, 'a4')
        end
        square = white.get_square('a4')
        find_valid_moves(square)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('a5')))
            white.move_to_new_square(square.notation, 'a5')
        end
        board.display_board
    end
end
Game.new.play

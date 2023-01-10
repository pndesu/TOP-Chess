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
        
        square = white.get_square('d2')
        target_square = get_square('d4')
        square.piece.update_valid_moves
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square)) 

        square = white.get_square('e1')
        target_square = get_square('d2')
        square.piece.update_valid_moves
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        board.display_board
    end
end
Game.new.play

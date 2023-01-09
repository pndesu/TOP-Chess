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

        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('d4')))
            white.move_to_new_square(square.notation, 'd4')
        end

        square = black.get_square('d7')
        if (check_valid_side?(square, 'black') && check_valid_move?(square, get_square('d5')))
            black.move_to_new_square(square.notation, 'd5')
        end

        square = white.get_square('c1')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('f4')))
            white.move_to_new_square(square.notation, 'f4')
        end

        square = black.get_square('g8')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, get_square('f6')))
            black.move_to_new_square(square.notation, 'f6')
        end

        square = white.get_square('f4')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('c7')))
            white.move_to_new_square(square.notation, 'c7')
        end

        square = black.get_square('h8')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, get_square('g8')))
            black.move_to_new_square(square.notation, 'g8')
        end

        square = white.get_square('c7')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('d8')))
            white.move_to_new_square(square.notation, 'd8')
        end

        square = black.get_square('e8')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, get_square('d8')))
            black.move_to_new_square(square.notation, 'd8')
        end

        square = white.get_square('e2')
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('e4')))
            white.move_to_new_square(square.notation, 'e4')
        end

        square = black.get_square('d5')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, get_square('e4')))
            black.move_to_new_square(square.notation, 'e4')
        end

        board.display_board
    end
end
Game.new.play

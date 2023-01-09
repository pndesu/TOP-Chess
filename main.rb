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
        if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square)) #Code starts to get chunky, game class knows too much
            unless (to_create_enpassant?(square, target_square))                            # (or action module is too stacked),
                move_to_new_square(square, target_square)                                   # needs to refactor into better loop and design enpassant better
            else
                enpassant_pawn = create_enpassant_square(square)
                clear_enpassant_square(white.enpassant_pawn)
                white.enpassant_pawn << enpassant_pawn
                move_to_new_square(square, target_square)
            end
        end

        square = black.get_square('e7')
        target_square = get_square('e5')
        if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
            unless (to_create_enpassant?(square, target_square))
                move_to_new_square(square, target_square)
            else
                create_enpassant_square(square)
                move_to_new_square(square, target_square)
            end
        end

        square = white.get_square('d4')
        target_square = get_square('d5')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
            unless (to_create_enpassant?(square, target_square))
                move_to_new_square(square, target_square)
            else
                create_enpassant_square(square)
                move_to_new_square(square, target_square)
            end
        end

        square = black.get_square('e5')
        target_square = get_square('e4')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
            unless (to_create_enpassant?(square, target_square))
                move_to_new_square(square, target_square)
            else
                create_enpassant_square(square)
                move_to_new_square(square, target_square)
            end
        end

        square = white.get_square('d5')
        target_square = get_square('e6')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
            unless (to_create_enpassant?(square, target_square))
                move_to_new_square(square, target_square)
            else
                create_enpassant_square(square)
                move_to_new_square(square, target_square)
            end
        end

        square = black.get_square('e4')
        target_square = get_square('f3')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
            unless (to_create_enpassant?(square, target_square))
                move_to_new_square(square, target_square)
            else
                create_enpassant_square(square)
                move_to_new_square(square, target_square)
            end
        end

        board.display_board
    end
end
Game.new.play

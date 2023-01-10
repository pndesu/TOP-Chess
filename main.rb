require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'
require 'yaml'
class Game
    include PieceAction, SquareAction
    def play
        board = Board.new
        white = White.new
        black = Black.new

        white_pieces =White.pieces
        square = white.get_square('d2')
        target_square = get_square('d4')
        square.piece.update_valid_moves
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square)) 

        square = white.get_square('d4')
        target_square = get_square('d5')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = black.get_square('e7')
        target_square = get_square('e5')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = white.get_square('d5')
        target_square = get_square('e6')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = black.get_square('d7')
        target_square = get_square('d5')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)
        
        square = black.get_square('d5')
        target_square = get_square('d4')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = white.get_square('e2')
        target_square = get_square('e4')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = black.get_square('d4')
        target_square = get_square('e3')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'black') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        square = white.get_square('f2')
        target_square = get_square('e3')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)

        board.display_board
    end
end
Game.new.play

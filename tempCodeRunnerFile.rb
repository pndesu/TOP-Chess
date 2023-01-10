square = white.get_square('e2')
        target_square = get_square('e4')
        square.piece.update_valid_moves
        File.open("old_board.yml", "w"){|file| file.write(Board.board.to_yaml)}
        move_to_new_square(square, target_square) if (check_valid_side?(square, 'white') && check_valid_move?(square, target_square))
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        new_board = Board.board
        check_board_for_enpassant(old_board, new_board)
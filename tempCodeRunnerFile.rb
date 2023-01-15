target_square.piece.update_valid_moves
        White.pieces.each{|piece| piece.update_valid_moves}
        new_board = Board.board
        if check?('black')
            old_board = (Psych.unsafe_load(File.read("old_board.yml")))
            board.update_board(old_board[0])
            white.update_piece(old_board[1])
            black.update_piece(old_board[2])
            White.pieces.each{|piece| piece.update_valid_moves}
            puts ErrorMessage('invalid_move')
        else
            old_board = Psych.unsafe_load(File.read("old_board.yml"))
            check_board_for_enpassant(old_board, new_board)
        end
square = black.get_square('b8')
        # target_square = get_square('a6')
        # square.piece.update_valid_moves
        # White.pieces.each{|piece| piece.update_supporting_squares}
        # File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces].to_yaml)}
        # move_to_new_square(square, target_square) if (check_valid_side?(square, 'black') && check_valid_piece_move?(square, target_square))
        # White.pieces.each{|piece| piece.update_valid_moves}
        # if check?('black')
        #     old_board = (Psych.unsafe_load(File.read("old_board.yml")))
        #     board.update_board(old_board[0])
        #     white.update_piece(old_board[1])
        #     black.update_piece(old_board[2])
        #     White.pieces.each{|piece| piece.update_valid_moves}
        #     puts ErrorMessage('invalid_move')
        # else
        #     target_square.piece.update_valid_moves
        #     new_board = Board.board
        #     old_board = Psych.unsafe_load(File.read("old_board.yml"))
        #     check_board_for_enpassant(old_board, new_board)
        # end
def black_turn
    puts "Black's turn"
    Black.pieces.each{|piece| piece.update_valid_moves}
    input = get_user_input('black')
    square = get_square(input[0])
    target_square = get_square(input[1])
    File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces].to_yaml)}
    if square.piece.instance_of?(King) && (target_square.position[1] - square.position[1]).abs == 2 && check_castle_rights?('black', target_square)
        black.short_castle if square.position[1] < target_square.position[1]
        black.long_castle if square.position[1] > target_square.position[1]
    elsif (check_valid_side?(square, 'black') && check_valid_piece_move?(square, target_square))
        move_to_new_square(square, target_square) 
    else
        puts ErrorMessage('invalid_move')
        change_square_color(square, square.color)
        black_turn
    end
    White.pieces.each{|piece| piece.update_valid_moves}
    if check?('black')
        reload_board
        black_turn
    else
        continue_board
        change_square_color(target_square, 'green')
        last_move = [get_square(input[0]), get_square(input[1])]
        Black.pieces.each{|piece| piece.update_valid_moves}
        Black.pieces.each{|piece| piece.update_supporting_squares}
        board.display_board
        @turn += 1
        take_turn
    end
end
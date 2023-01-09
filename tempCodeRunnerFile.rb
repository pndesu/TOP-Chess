square = white.get_square('a2')
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('a4')))
            white.move_to_new_square(square.notation, 'a4')
        end
        square = white.get_square('a4')
        moves = find_valid_moves(square)
        square.update_valid_moves(moves)
        if (check_valid_side?(square, 'white') && check_valid_move?(square, get_square('a5')))
            white.move_to_new_square(square.notation, 'a5')
        end
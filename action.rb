module PieceAction
    def spawn_pawn(side)
        (0..7).each{|i| Board.board[6][i].piece = Pawn.new(side: side, piece_symbol: '♙', on_square: Board.board[6][i])} if side == 'white'
        (0..7).each{|i| Board.board[1][i].piece = Pawn.new(side: side, piece_symbol: '♟︎', on_square: Board.board[1][i])} if side == 'black'
    end
    
    def spawn_knight(side)
        [[7,1], [7,6]].each{|i| Board.board[i[0]][i[1]].piece = Knight.new(side: side, piece_symbol: '♘', on_square: Board.board[i[0]][i[1]])} if side == 'white'
        [[0,1], [0,6]].each{|i| Board.board[i[0]][i[1]].piece = Knight.new(side: side, piece_symbol: '♞', on_square: Board.board[i[0]][i[1]])} if side == 'black'
    end

    def spawn_bishop(side)
        [[7,2], [7,5]].each{|i| Board.board[i[0]][i[1]].piece = Bishop.new(side: side, piece_symbol: '♗', on_square: Board.board[i[0]][i[1]])} if side == 'white'
        [[0,2], [0,5]].each{|i| Board.board[i[0]][i[1]].piece = Bishop.new(side: side, piece_symbol: '♝', on_square: Board.board[i[0]][i[1]])} if side == 'black'
    end
    
    def spawn_rook(side)
        [[7,0], [7,7]].each{|i| Board.board[i[0]][i[1]].piece = Rook.new(side: side, piece_symbol: '♖', on_square: Board.board[i[0]][i[1]])} if side == 'white'
        [[0,0], [0,7]].each{|i| Board.board[i[0]][i[1]].piece = Rook.new(side: side, piece_symbol: '♜', on_square: Board.board[i[0]][i[1]])} if side == 'black'
    end

    def spawn_queen(side)
        [[7,3]].each{|i| Board.board[i[0]][i[1]].piece = Queen.new(side: side, piece_symbol: '♕', on_square: Board.board[i[0]][i[1]])} if side == 'white'
        [[0,3]].each{|i| Board.board[i[0]][i[1]].piece = Queen.new(side: side, piece_symbol: '♛', on_square: Board.board[i[0]][i[1]])} if side == 'black'
    end

    def spawn_king(side)
        [[7,4]].each{|i| Board.board[i[0]][i[1]].piece = King.new(side: side, piece_symbol: '♔', on_square: Board.board[i[0]][i[1]])} if side == 'white'
        [[0,4]].each{|i| Board.board[i[0]][i[1]].piece = King.new(side: side, piece_symbol: '♚', on_square: Board.board[i[0]][i[1]])} if side == 'black'
    end

    # def find_valid_moves(square)
    #     case square.piece
    #     when Pawn then find_valid_pawn_moves(square)
    #     when Knight then find_valid_knight_moves(square)
    #     when Bishop then find_valid_bishop_moves(square)
    #     when Rook then find_valid_rook_moves(square)
    #     when Queen then find_valid_queen_moves(square)
    #     when King then find_valid_king_moves(square)
    #     end
    # end

    

    def find_valid_pawn_moves(square, square_row = square.position[0], square_col = square.position[1]) #Lacking en passsant
        if square.piece.side == 'white'
            basic_moves = [Board.board[square_row - 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row - 1][square_col - 1], Board.board[square_row - 1][square_col + 1]].compact
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.piece != nil} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if (blocked_square != nil && blocked_square.piece != nil && blocked_square.piece.side == 'black')}.compact
            moves = basic_moves - ahead_square + diag_square
        else
            basic_moves = [Board.board[square_row + 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row + 1][square_col - 1], Board.board[square_row + 1][square_col + 1]]
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.piece != nil} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if (blocked_square != nil && blocked_square.piece != nil && blocked_square.piece.side == 'white')}.compact
            moves = basic_moves - ahead_square + diag_square
        end
        moves
    end

    def find_valid_knight_moves(square, square_row = square.position[0], square_col = square.position[1])
        basic_moves = [[2,1],[2,-1],[1,2],[1,-2],[-2,1],[-2,-1],[-1,2],[-1,-2]]
        moves = basic_moves.map{|move| Board.board[square_row + move[0]][square_col + move[1]] if ((square_row + move[0]).between?(0,7) && (square_col + move[1]).between?(0,7))}.compact
        if square.piece.side == 'white'
            moves = moves.select{|move| move.piece == nil || move.piece.side != 'white'}
        else
            moves = moves.select{|move| move.piece == nil || move.piece.side != 'black'}
        end
        moves
    end

    def find_valid_bishop_moves(square, square_row = square.position[0], square_col = square.position[1])
        diagonal_squares = find_squares_diagonal(square)
        occupied_diagonal_squares = find_occupied_squares_diagonal(square)
        basic_moves = diagonal_squares.each_with_index
                                      .map{|direction, index| direction = direction[..direction.find_index(occupied_diagonal_squares[index])]}
                                      .reject{|direction| direction.length == 0 || direction.length == 1 && direction[0] == nil}
        if square.piece.side == 'white'
            moves = basic_moves.map{|direction| (direction[-1].piece != nil && direction[-1].piece.side == 'white')? direction[..-2] : direction}.flatten
        else
            moves = basic_moves.map{|direction| (direction[-1].piece != nil && direction[-1].piece.side == 'black')? direction[..-2] : direction}.flatten
        end
        moves
    end

    def find_valid_rook_moves(square, square_row = square.position[0], square_col = square.position[1])
        vertical_squares = find_squares_vertical(square)
        horizontal_squares = find_squares_horizontal(square)
        vertical_horizontal_squares = (vertical_squares + horizontal_squares)
        occupied_vertical_horizontal_squares = find_occupied_squares_vertical(square) + find_occupied_squares_horizontal(square)
        basic_moves = vertical_horizontal_squares.each_with_index
                                                 .map{|direction, index| direction = direction[..direction.find_index(occupied_vertical_horizontal_squares[index])].compact}
                                                 .reject{|direction| direction.length == 0 || direction.length == 1 && direction[0] == nil}
        if square.piece.side == 'white'
            moves = basic_moves.map{|direction| (direction[-1].piece != nil && direction[-1].piece.side == 'white')? direction[..-2] : direction}.flatten
        else
            moves = basic_moves.map{|direction| (direction[-1].piece != nil && direction[-1].piece.side == 'black')? direction[..-2] : direction}.flatten
        end
        moves
    end

    def find_valid_queen_moves(square, square_row = square.position[0], square_col = square.position[1])
        moves = find_valid_bishop_moves(square) + find_valid_rook_moves(square)
        moves
    end

    def find_valid_king_moves(square, square_row = square.position[0], square_col = square.position[1])
        basic_moves = find_squares_vertical(square) + find_squares_diagonal(square) + find_squares_horizontal(square)
        basic_moves = basic_moves.reject{|direction| direction.length == 0 || direction.length == 1 && direction[0] == nil}
        
        if square.piece.side == 'white' #Needs to update all white pieces valid move after white makes a move
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && (direction[0].piece == nil || (direction[0].piece.side == 'black' && direction[0].piece.supported == 0)))}.compact
            Black.pieces.each{|piece| moves -= piece.valid_moves}
        else
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && (direction[0].piece == nil || (direction[0].piece.side == 'white' && direction[0].piece.supported == 0)))}.compact
            White.pieces.each{|piece| moves -= piece.valid_moves}
        end
        moves
    end

    def find_occupied_squares_vertical(square, square_row = square.position[0], square_col = square.position[1])
        vertical_squares = find_squares_vertical(square)
        toward_white_side = vertical_squares[0].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))} #If doesn't have blocked square returns nil?
        toward_black_side = vertical_squares[1].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_white_side = toward_white_side.compact unless toward_white_side.all?{|x| x.nil?}
        toward_black_side = toward_black_side.compact unless toward_black_side.all?{|x| x.nil?}
        [toward_white_side[0], toward_black_side[0]]
    end

    def find_occupied_squares_diagonal(square, square_row = square.position[0], square_col = square.position[1])
        diagonal_squares = find_squares_diagonal(square)
        toward_white_left_side = diagonal_squares[0].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_white_right_side = diagonal_squares[1].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_black_left_side = diagonal_squares[2].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_black_right_side = diagonal_squares[3].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_white_left_side = toward_white_left_side.compact unless toward_white_left_side.all?{|x| x.nil?}
        toward_white_right_side = toward_white_right_side.compact unless toward_white_right_side.all?{|x| x.nil?}
        toward_black_left_side = toward_black_left_side.compact unless toward_black_left_side.all?{|x| x.nil?}
        toward_black_right_side = toward_black_right_side.compact unless toward_black_right_side.all?{|x| x.nil?}
        [toward_white_left_side[0], toward_white_right_side[0], toward_black_left_side[0], toward_black_right_side[0]]
    end

    def find_occupied_squares_horizontal(square, square_row = square.position[0], square_col = square.position[1])
        horizontal_squares = find_squares_horizontal(square)
        toward_left_side = horizontal_squares[0].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))} #If doesn't have blocked square returns nil?
        toward_right_side = horizontal_squares[1].map{|square| square if (square != nil && square.piece != nil && !square.piece.instance_of?(EnPassant))}
        toward_left_side = toward_left_side.compact unless toward_left_side.all?{|x| x.nil?}
        toward_right_side = toward_right_side.compact unless toward_right_side.all?{|x| x.nil?}
        [toward_left_side[0], toward_right_side[0]]
    end

    def find_squares_vertical(square, square_row = square.position[0], square_col = square.position[1])
        toward_white_side = (1..7).map{|i| Board.board[square_row + i][square_col] if (square_row + i).between?(0,7)}.compact #If doesn't have blocked square returns nil?
        toward_black_side = (1..7).map{|i| Board.board[square_row - i][square_col] if (square_row - i).between?(0,7)}.compact
        [toward_white_side, toward_black_side]
    end

    def find_squares_diagonal(square, square_row = square.position[0], square_col = square.position[1])
        toward_white_left_side = (1..[7 - square_row, square_col].min).map{|i| Board.board[square_row + i][square_col - i]}
        toward_white_right_side = (1..[7 - square_row, 7 - square_col].min).map{|i| Board.board[square_row + i][square_col + i]}
        toward_black_left_side = (1..[square_row, square_col].min).map{|i| Board.board[square_row - i][square_col - i]}
        toward_black_right_side = (1..[square_row, 7 - square_col].min).map{|i| Board.board[square_row - i][square_col + i]}
        [toward_white_left_side, toward_white_right_side, toward_black_left_side, toward_black_right_side]
    end

    def find_squares_horizontal(square, square_row = square.position[0], square_col = square.position[1])
        toward_left_side = (1..7).map{|i| Board.board[square_row][square_col - i] if (square_col - i).between?(0,7)}.compact
        toward_right_side = (1..7).map{|i| Board.board[square_row][square_col + i] if (square_col + i).between?(0,7)}.compact
        [toward_left_side, toward_right_side]
    end

    def pieces_checking_king(side)
        checking_pieces = Black.pieces.map{|piece| piece.on_square if piece.valid_moves.include?(White.pieces[0].on_square)}.compact if side == 'white'
        checking_pieces = White.pieces.map{|piece| piece.on_square if piece.valid_moves.include?(Black.pieces[0].on_square)}.compact if side == 'black'
        checking_pieces
    end

    def check?(side)
        (pieces_checking_king(side).length > 0) ? true : false
    end

    def checkmate?(side)
        if check?(side)
            if pieces_checking_king(side).length == 1
                (king_has_no_moves?(side) && cannnot_block_check?(side))? true : false
            else
                king_has_no_moves?(side)? true : false
            end
        end
    end

    
    def checking_direction_squares(side) #Return direction of squares including checking pieces until squares next to king
        pieces = pieces_checking_king(side)
        (side == 'white')? king = White.pieces[0] : king = Black.pieces[0]
        in_check_squares = []
        pieces.each do |piece|
            if piece.instance_of?(Pawn) || piece.instance_of?(Knight)
                in_check_squares << piece.on_square 
            else
                if piece.position[0] == king.position[0]
                    if piece.position[1] < king.position[1]
                        (0..king.position[1] - 1 - piece.position[1]).each{|i| in_check_squares << Board.board[piece.position[0]][piece.position[1] + i]}
                    else
                        (0..piece.position[1]- 1 - king.position[1]).each{|i| in_check_squares << Board.board[piece.position[0]][piece.position[1] - i]}
                    end
                elsif piece.position[0] < king.position[0]
                    if piece.position[1] < king.position[1]
                        (0..king.position[1] - 1 - piece.position[1]).each{|i| in_check_squares << Board.board[piece.position[0] + i][piece.position[1] + i]}
                    else
                        (0..piece.position[1]- 1 - king.position[1]).each{|i| in_check_squares << Board.board[piece.position[0] + i][piece.position[1] - i]}
                    end
                else
                    if piece.position[1] < king.position[1]
                        (0..king.position[1] - 1 - piece.position[1]).each{|i| in_check_squares << Board.board[piece.position[0] - i][piece.position[1] + i]}
                    else
                        (0..piece.position[1]- 1 - king.position[1]).each{|i| in_check_squares << Board.board[piece.position[0] - i][piece.position[1] - i]}
                    end
                end
            end
        end
        in_check_squares
    end

    def king_has_no_moves?(side) ## Maybe need refactor method with side argument, change into side class?
        ((White.pieces[0].valid_moves - checking_direction_squares(side)).length == 0)? true : false if side == 'white'
        ((Black.pieces[0].valid_moves - checking_direction_squares(side)).length == 0)? true : false if side == 'black'
    end

    def cannnot_block_check?(side)
        in_check_squares = checking_direction_squares(side)
        White.pieces.all?{|piece| (piece.valid_moves - in_check_squares).length == piece.valid_moves.length}? true : false if side == 'white'
        Black.pieces.all?{|piece| (piece.valid_moves - in_check_squares).length == piece.valid_moves.length}? true : false if side == 'black'
    end

    def in_check_between_short_castle?(side) #Can be refactored to be more succint
        return Black.pieces.any?{|piece| piece.valid_moves.include?(Board.board[7][5]) || piece.valid_moves.include?(Board.board[7][6])} if side == 'white'
        return White.pieces.any?{|piece| piece.valid_moves.include?(Board.board[0][5]) || piece.valid_moves.include?(Board.board[0][6])} if side == 'black'
    end

    def in_check_between_long_castle?(side)
        return Black.pieces.any?{|piece| piece.valid_moves.include?(Board.board[7][2]) || piece.valid_moves.include?(Board.board[7][3])} if side == 'white'
        return White.pieces.any?{|piece| piece.valid_moves.include?(Board.board[0][2]) || piece.valid_moves.include?(Board.board[0][3])} if side == 'black'
    end
    
    def no_pieces_between_short_castle?(side)
        return (Board.board[7][5].piece == nil && Board.board[7][6].piece == nil) if side == 'white'
        return (Board.board[0][5].piece == nil && Board.board[0][6].piece == nil) if side == 'black'
    end

    def no_pieces_between_long_castle?(side)
        return (Board.board[7][2].piece == nil && Board.board[7][3].piece == nil) if side == 'white'
        return (Board.board[0][2].piece == nil && Board.board[0][3].piece == nil) if side == 'black'
    end

    def check_castle_rights?(side, square)
        if side == 'white'
            if White.pieces[0].position[1] < square.position[1]
                rook = White.pieces.select{|piece| piece.instance_of?(Rook) && piece.origin == [7,7]}[0]
                return (rook != nil && White.pieces[0].have_moved == 0 && rook.have_moved == 0 && no_pieces_between_short_castle?('white') && !in_check_between_short_castle?('white') && !check?('white'))
            else
                rook = White.pieces.select{|piece| piece.instance_of?(Rook) && piece.origin == [7,0]}[0]
                return (rook != nil && White.pieces[0].have_moved == 0 && rook.have_moved == 0 && no_pieces_between_long_castle?('white') && !in_check_between_long_castle?('white') && !check?('white'))
            end
        else
            if Black.pieces[0].position[1] < square.position[1]
                rook = Black.pieces.select{|piece| piece.instance_of?(Rook) && piece.origin == [0,7]}[0]
                return (rook != nil && Black.pieces[0].have_moved == 0 && rook.have_moved == 0 && no_pieces_between_short_castle?('black') && !in_check_between_short_castle?('black') && !check?('black'))
            else
                rook = Black.pieces.select{|piece| piece.instance_of?(Rook) && piece.origin == [0,0]}[0]
                return (rook != nil && Black.pieces[0].have_moved == 0 && rook.have_moved == 0 && no_pieces_between_long_castle?('black') && !in_check_between_long_castle?('black') && !check?('black'))
            end
        end
    end

end

module SquareAction
    def get_square(position)
        x_axis = ['8', '7', '6', '5', '4', '3', '2', '1']
        y_axis = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        position = position.split('')
        position = position.map do |value|
            if y_axis.include?(value)
                value = y_axis.find_index(value)
            elsif x_axis.include?(value)
                value = x_axis.find_index(value)
            end
        end
        Board.board[position[1]][position[0]]
    end

    def check_valid_side?(square, side)
        (square.piece.side == side)? true : false
    end

    def check_valid_piece_move?(old_square, new_square)
        old_square.piece.valid_moves.include?(new_square)? true : false
    end

    def move_to_new_square(old_square, new_square)
        take_enpassant(old_square, new_square)
        if new_square.piece != nil && !new_square.piece.instance_of?(EnPassant)
            White.pieces.delete_at(White.pieces.find_index(new_square.piece)) if new_square.piece.side == 'white'
            Black.pieces.delete_at(Black.pieces.find_index(new_square.piece)) if new_square.piece.side == 'black'
        end
        new_square.piece = old_square.piece
        new_square.piece.on_square = new_square
        new_square.piece.position = new_square.position
        promote_pawn(old_square, new_square)
        old_square.piece = nil
    end

    def promote_pawn(old_square, new_square)
        if (old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'white' && new_square.position[0] == 0)
            White.pieces.delete(old_square.piece)
            print_promote_instruction
            loop do
                print 
                choice = gets.chomp
                if choice.match(/^[1-4]$/)
                    case choice
                        when '1' then new_square.piece = Queen.new(side: 'white', piece_symbol: '♕', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '2' then new_square.piece = Rook.new(side: 'white', piece_symbol: '♖', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '3' then new_square.piece = Knight.new(side: 'white', piece_symbol: '♘', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '4' then new_square.piece = Bishop.new(side: 'white', piece_symbol: '♗', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                    end
                    break
                end
            end
            White.pieces.push(new_square.piece)
        elsif (old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'black' && new_square.position[0] == 7)
            Black.pieces.delete(old_square.piece)
            print_promote_instruction
            loop do
                print 
                choice = gets.chomp
                if choice.match(/^[1-4]$/)
                    case choice
                        when '1' then new_square.piece = Queen.new(side: 'black', piece_symbol: '♛', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '2' then new_square.piece = Rook.new(side: 'black', piece_symbol: '♜', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '3' then new_square.piece = Knight.new(side: 'black', piece_symbol: '♞', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                        when '4' then new_square.piece = Bishop.new(side: 'black', piece_symbol: '♝', on_square: Board.board[new_square.position[0]][new_square.position[1]])
                    end
                    break
                end
            end
            Black.pieces.push(new_square.piece)
        end
    end

    def print_promote_instruction
        instruction = <<-HEREDOC
Enter 1 to promote to a queen
Enter 2 to promote to a rook
Enter 3 to promote to a knight
Enter 4 to promote to a bishop
            HEREDOC
            print instruction
    end

    def take_enpassant(old_square, new_square)
        if old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'white' && new_square.piece.instance_of?(EnPassant)
            Black.pieces.delete_at(Black.pieces.find_index(Board.board[new_square.position[0] + 1][new_square.position[1]].piece))
            Board.board[new_square.position[0] + 1][new_square.position[1]].piece = nil 
        end
        if old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'black' && new_square.piece.instance_of?(EnPassant)
            White.pieces.delete_at(White.pieces.find_index(Board.board[new_square.position[0] - 1][new_square.position[1]].piece))
            Board.board[new_square.position[0] - 1][new_square.position[1]].piece = nil 
        end
    end

    def check_board_for_enpassant(old_board, new_board)
        (0..7).each do |i| 
            Board.board[5][i].piece = nil if Board.board[5][i].piece.instance_of?(EnPassant)
            if old_board[6][i].piece.instance_of?(Pawn) && new_board[4][i].piece.instance_of?(Pawn) && new_board[5][i].piece == nil && old_board[6][i].piece.side == new_board[4][i].piece.side
                Board.board[5][i].piece = EnPassant.new(side: 'white')
            end
        end

        (0..7).each do |i|
            Board.board[2][i].piece = nil if Board.board[2][i].piece.instance_of?(EnPassant)
            if old_board[1][i].piece.instance_of?(Pawn) && new_board[3][i].piece.instance_of?(Pawn) && new_board[2][i].piece == nil && old_board[1][i].piece.side == new_board[3][i].piece.side
                Board.board[2][i].piece = EnPassant.new(side: 'black')
            end
        end
    end
    
end

module Display
    def ErrorMessage(message)
        {
            'invalid_move' => "Please enter a valid move!",
            'invalid_input' => "Please enter a valid input!"
        }[message]
    end

    def change_square_color(square, color)
        square.new_color = color
    end

    def change_valid_move_squares_color(square, mode)
        if mode == 'on'
            square.piece.valid_moves.each do |position|
                if position.piece == nil
                    change_square_color(position, 'round')
                else
                    change_square_color(position, 'red')
                end
            end
        else
            square.piece.valid_moves.each do |position|
                change_square_color(position, position.color)
            end
        end
    end
end
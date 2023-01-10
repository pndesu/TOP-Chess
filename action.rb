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
        # vertical = find_occupied_squares_vertical(square)
        # diagonal = find_occupied_squares_diagonal(square)
        if square.piece.side == 'white'
            basic_moves = [Board.board[square_row - 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row - 1][square_col - 1], Board.board[square_row - 1][square_col + 1]]
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.piece != nil} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if (blocked_square.piece != nil && blocked_square.piece.side == 'black')}
            moves = basic_moves - ahead_square + diag_square
        else
            basic_moves = [Board.board[square_row + 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row + 1][square_col - 1], Board.board[square_row + 1][square_col + 1]]
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.piece != nil} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if (blocked_square.piece != nil && blocked_square.piece.side == 'white')}
            moves = basic_moves - ahead_square + diag_square
        end
        moves
    end

    def find_valid_knight_moves(square, square_row = square.position[0], square_col = square.position[1])
        basic_moves = [[2,1],[2,-1],[1,2],[1,-2],[-2,1],[-2,-1],[-1,2],[-1,-2]]
        moves = basic_moves.map{|move| Board.board[square_row + move[0]][square_col + move[1]] if ((square_row + move[0]).between?(0,7) && (square_col + move[1]).between?(0,7))}.compact
        if square.piece.side == 'white'
            moves = moves.select{|move| move.piece != nil && move.piece.side != 'white'}
        else
            moves = moves.select{|move| move.piece != nil && move.piece.side != 'black'}
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
                                                 .map{|direction, index| direction = direction[..direction.find_index(occupied_vertical_horizontal_squares[index])]}
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
        
        if square.piece.side == 'white'
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && (direction[0].piece == nil || direction[0].piece.side != 'white'))}
        else
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && (direction[0].piece == nil || direction[0].piece.side != 'black'))}
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
        toward_white_side = (1..7).map{|i| Board.board[square_row + i][square_col] if (square_row + i).between?(1,7)} #If doesn't have blocked square returns nil?
        toward_black_side = (1..7).map{|i| Board.board[square_row - i][square_col] if (square_row - i).between?(1,7)}
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
        toward_left_side = (1..7).map{|i| Board.board[square_row][square_col - i] if (square_col - i).between?(1,7)}.compact
        toward_right_side = (1..7).map{|i| Board.board[square_row][square_col + i] if (square_col + i).between?(1,7)}.compact
        [toward_left_side, toward_right_side]
    end

    # def to_create_enpassant?(old_square, new_square)
    #     (old_square.piece_name == 'pawn' && (new_square.position[0] - old_square.position[0]).abs == 2)? true : false
    # end

    # def create_enpassant_square(square, square_row = square.position[0], square_col = square.position[1])
    #     if square.side == 'white'
    #         Board.board[square_row - 1][square_col].piece_name = 'enpassant_pawn'
    #         Board.board[square_row - 1][square_col].side = 'white'
    #     else
    #         Board.board[square_row + 1][square_col].piece_name = 'enpassant_pawn'
    #         Board.board[square_row + 1][square_col].side = 'black'
    #     end
    #     Board.board[square_row - 1][square_col]
    # end

    # def clear_enpassant_square(enpassant_pawn)
    #     enpassant_pawn.each do |square|
    #         square.piece_name = ''
    #         square.side = ''
    #     end
    # end
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

    def check_valid_move?(old_square, new_square)
        old_square.piece.valid_moves.include?(new_square)? true : false
    end

    def move_to_new_square(old_square, new_square)
        Board.board[new_square.position[0] + 1][new_square.position[1]].piece = nil if old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'white' && new_square.piece.instance_of?(EnPassant)
        Board.board[new_square.position[0] - 1][new_square.position[1]].piece = nil if old_square.piece.instance_of?(Pawn) && old_square.piece.side == 'black' && new_square.piece.instance_of?(EnPassant)
        new_square.piece = old_square.piece
        new_square.piece.on_square = new_square
        old_square.piece = nil
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

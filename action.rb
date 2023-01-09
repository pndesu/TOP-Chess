module PieceAction
    def spawn_pawn(side)
        if side == 'white'
            position = []
            (0..7).each{|i| position << [6,i]}
            Pawn.new('white', position)
        else
            position = []
            (0..7).each{|i| position << [1,i]}
            Pawn.new('black', position)
        end
    end
    
    def spawn_knight(side)
        if side == 'white'
            position = [[7,1], [7,6]]
            Knight.new('white', position)
        else
            position = [[0,1], [0,6]]
            Knight.new('black', position)
        end
    end

    def spawn_bishop(side)
        if side == 'white'
            position = [[7,2], [7,5]]
            Bishop.new('white', position)
        else
            position = [[0,2], [0,5]]
            Bishop.new('black', position)
        end
    end

    def spawn_rook(side)
        if side == 'white'
            position = [[7,0], [7,7]]
            Rook.new('white', position)
        else
            position = [[0,0], [0,7]]
            Rook.new('black', position)
        end
    end

    def spawn_queen(side)
        if side == 'white'
            position = [[7,3]]
            Queen.new('white', position)
        else
            position = [[0,3]]
            Queen.new('black', position)
        end
    end

    def spawn_king(side)
        if side == 'white'
            position = [[7,4]]
            King.new('white', position)
        else
            position = [[0,4]]
            King.new('black', position)
        end
    end

    def find_valid_moves(square)
        case square.piece_name
        when 'pawn' then find_valid_pawn_moves(square)
        when 'knight' then find_valid_knight_moves(square)
        when 'bishop' then find_valid_bishop_moves(square)
        when 'rook' then find_valid_rook_moves(square)
        when 'queen' then find_valid_queen_moves(square)
        when 'king' then find_valid_king_moves(square)
        end
    end

    def find_valid_pawn_moves(square, square_row = square.position[0], square_col = square.position[1]) #Lacking en passsant
        # vertical = find_occupied_squares_vertical(square)
        # diagonal = find_occupied_squares_diagonal(square)
        if square.side == 'white'
            basic_moves = [Board.board[square_row - 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row - 1][square_col - 1], Board.board[square_row - 1][square_col + 1]]
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.side != ''} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if blocked_square.side == 'black'}
            moves = basic_moves - ahead_square + diag_square
        else
            basic_moves = [Board.board[square_row + 1][square_col]]
            basic_diagonal_moves = [Board.board[square_row + 1][square_col - 1], Board.board[square_row + 1][square_col + 1]]
            ahead_square = basic_moves.map{|blocked_square| blocked_square if blocked_square.side != ''} 
            diag_square = basic_diagonal_moves.map{|blocked_square| blocked_square if blocked_square.side == 'white'}
            moves = basic_moves - ahead_square + diag_square
        end
        moves
    end

    def find_valid_knight_moves(square, square_row = square.position[0], square_col = square.position[1])
        basic_moves = [[2,1],[2,-1],[1,2],[1,-2],[-2,1],[-2,-1],[-1,2],[-1,-2]]
        moves = basic_moves.map{|move| Board.board[square_row + move[0]][square_col + move[1]] if ((square_row + move[0]).between?(0,7) && (square_col + move[1]).between?(0,7))}.compact
        if square.side == 'white'
            moves = moves.select{|move| move.side != 'white'}
        else
            moves = moves.select{|move| move.side != 'black'}
        end
        moves
    end

    def find_valid_bishop_moves(square, square_row = square.position[0], square_col = square.position[1])
        diagonal_squares = find_squares_diagonal(square)
        occupied_diagonal_squares = find_occupied_squares_diagonal(square)
        basic_moves = diagonal_squares.each_with_index
                                      .map{|direction, index| direction = direction[..direction.find_index(occupied_diagonal_squares[index])]}
                                      .reject{|direction| direction.length == 0 || direction.length == 1 && direction[0] == nil}
        if square.side == 'white'
            moves = basic_moves.map{|direction| (direction[-1].side == 'white')? direction[..-2] : direction}.flatten
        else
            moves = basic_moves.map{|direction| (direction[-1].side == 'black')? direction[..-2] : direction}.flatten
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
        if square.side == 'white'
            moves = basic_moves.map{|direction| (direction[-1].side == 'white')? direction[..-2] : direction}.flatten
        else
            moves = basic_moves.map{|direction| (direction[-1].side == 'black')? direction[..-2] : direction}.flatten
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
        
        if square.side == 'white'
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && direction[0].side != 'white')}
        else
            moves = basic_moves.map{|direction| direction[0] if (direction[0] != nil && direction[0].side != 'black')}
        end
        moves
    end

    def find_occupied_squares_vertical(square, square_row = square.position[0], square_col = square.position[1])
        vertical_squares = find_squares_vertical(square)
        toward_white_side = vertical_squares[0].map{|square| square if (square != nil && square.piece != ' ')} #If doesn't have blocked square returns nil?
        toward_black_side = vertical_squares[1].map{|square| square if (square != nil && square.piece != ' ')}
        toward_white_side = toward_white_side.compact unless toward_white_side.all?{|x| x.nil?}
        toward_black_side = toward_black_side.compact unless toward_black_side.all?{|x| x.nil?}
        [toward_white_side[0], toward_black_side[0]]
    end

    def find_occupied_squares_diagonal(square, square_row = square.position[0], square_col = square.position[1])
        diagonal_squares = find_squares_diagonal(square)
        toward_white_left_side = diagonal_squares[0].map{|square| square if (square != nil && square.piece != ' ')}
        toward_white_right_side = diagonal_squares[1].map{|square| square if (square != nil && square.piece != ' ')}
        toward_black_left_side = diagonal_squares[2].map{|square| square if (square != nil && square.piece != ' ')}
        toward_black_right_side = diagonal_squares[3].map{|square| square if (square != nil && square.piece != ' ')}
        toward_white_left_side = toward_white_left_side.compact unless toward_white_left_side.all?{|x| x.nil?}
        toward_white_right_side = toward_white_right_side.compact unless toward_white_right_side.all?{|x| x.nil?}
        toward_black_left_side = toward_black_left_side.compact unless toward_black_left_side.all?{|x| x.nil?}
        toward_black_right_side = toward_black_right_side.compact unless toward_black_right_side.all?{|x| x.nil?}
        [toward_white_left_side[0], toward_white_right_side[0], toward_black_left_side[0], toward_black_right_side[0]]
    end

    def find_occupied_squares_horizontal(square, square_row = square.position[0], square_col = square.position[1])
        horizontal_squares = find_squares_horizontal(square)
        toward_left_side = horizontal_squares[0].map{|square| square if (square != nil && square.piece != ' ')} #If doesn't have blocked square returns nil?
        toward_right_side = horizontal_squares[1].map{|square| square if (square != nil && square.piece != ' ')}
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

    def to_create_enpassant?(old_square, new_square)
        (old_square.piece_name == 'pawn' && (new_square.position[0] - old_square.position[0]).abs == 2)? true : false
    end

    def create_enpassant_square(square, square_row = square.position[0], square_col = square.position[1])
        if square.side == 'white'
            Board.board[square_row - 1][square_col].piece_name = 'enpassant_pawn'
            Board.board[square_row - 1][square_col].side = 'white'
        else
            Board.board[square_row + 1][square_col].piece_name = 'enpassant_pawn'
            Board.board[square_row + 1][square_col].side = 'black'
        end
        Board.board[square_row - 1][square_col]
    end

    def clear_enpassant_square(enpassant_pawn)
        enpassant_pawn.map do |square|
            square.piece_name = ''
            square.side = ''
        end
        enpassant_pawn = []
    end
end

module SquareAction
    def get_square(position) #Don't need to be in white/black class? If moved to and called in Square class in white/black turn, check square.side, if match caller side, proceed?
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

    def check_valid_side?(square, side = '')
        (square.side == side)? true : false
    end

    def check_valid_move?(old_square, new_square)
        old_square.valid_moves.include?(new_square)? true : false
    end

    def move_to_new_square(old_square, new_square)
        new_square.piece = old_square.piece
        new_square.side = old_square.side
        new_square.piece_name = old_square.piece_name
        reset_square(old_square)
    end

    def reset_square(square)
        square.piece = ' '
        square.side = ''
    end
end

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

    def move_to_new_square(old_position, new_position)
        old_square = get_square(old_position)
        new_square = get_square(new_position)
        new_square.piece = old_square.piece
        new_square.side = old_square.side
        reset_square(old_square)
    end

    def reset_square(square)
        square.piece = ' '
        square.side = ''
    end
end
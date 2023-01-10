require_relative 'board.rb'
require_relative 'action.rb'

class Pawn
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        if have_moved == 0
            @valid_moves = [Board.board[on_square.position[0] - 1][on_square.position[1]], 
                            Board.board[on_square.position[0] - 2][on_square.position[1]],
                            Board.board[on_square.position[0] - 1][on_square.position[1] - 1],
                            Board.board[on_square.position[0] - 1][on_square.position[1] + 1]] if side == 'white'
            @valid_moves = [Board.board[on_square.position[0] + 1][on_square.position[1]], 
                            Board.board[on_square.position[0] + 2][on_square.position[1]],
                            Board.board[on_square.position[0] + 1][on_square.position[1] - 1],
                            Board.board[on_square.position[0] + 1][on_square.position[1] + 1]] if side == 'black'
            @have_moved = 1
        elsif have_moved == 1
            @valid_moves = find_valid_pawn_moves(on_square)
        end
    end
end

class EnPassant
    attr_accessor :side, :piece_symbol
    def initialize(side:, piece_symbol: ' ')
        @side = side
        @piece_symbol = piece_symbol
    end
end

class Knight
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square
    def initialize(side:, piece_symbol:, valid_moves: [], on_square:)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_knight_moves(on_square)
    end
end

class Bishop
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_bishop_moves(on_square)
    end
end

class Rook
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_rook_moves(on_square)
    end
end

class Queen
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        if have_moved == 0
            @valid_moves = find_valid_queen_moves(on_square)
            have_moved = 1
        else
            @valid_moves = find_valid_queen_moves(on_square)
        end
    end
end

class King
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0)
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
    end

    def update_valid_moves(on_square: @on_square)
        if have_moved == 0
            @valid_moves = find_valid_king_moves(on_square)
            have_moved = 1
        else
            @valid_moves = find_valid_king_moves(on_square)
        end
    end
end

require_relative 'board.rb'
require_relative 'action.rb'

class Pawn
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved, :position, :supported, :supporting
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
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

    #Support and supported pieces: find blocked squares, assign to supported piece, increment piece.supported through to_support attribute of supporting piece
    #If piece move, find new blocked squares, 3 action: old_supported_piece - (old_supported_piece & new_supported_piece) = decrement
    #                                                   old_supported_piece & new_supported_piece = stay the same
    #                                                   new_supported_piece - (old_supported_piece & new_supported_piece) = increment
    def update_supporting_squares()
        old_supported_piece = supporting
        new_supported_piece = []
        if side == 'white'
            [[position[0]-1, position[1]-1], [position[0]-1, position[1]+1]].each do |diag_square|
                new_supported_piece << diag_square if (Board.board[diag_square[0]][diag_square[1]] != nil && Board.board[diag_square[0]][diag_square[1]].piece != nil && Board.board[diag_square[0]][diag_square[1]].piece.side == 'white')
            end
        else
            [[position[0]+1, position[1]-1], [position[0]+1, position[1]+1]].each do |diag_square|
                new_supported_piece << diag_square if (Board.board[diag_square[0]][diag_square[1]] != nil && Board.board[diag_square[0]][diag_square[1]].piece != nil && Board.board[diag_square[0]][diag_square[1]].piece.side == 'black')
            end
        end
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
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
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :position, :supported, :supporting
    def initialize(side:, piece_symbol:, valid_moves: [], on_square:, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_knight_moves(on_square)
    end

    def update_supporting_squares()
        old_supported_piece = supporting
        basic_moves = [[2,1],[2,-1],[1,2],[1,-2],[-2,1],[-2,-1],[-1,2],[-1,-2]]
        moves = basic_moves.map{|move| Board.board[position[0] + move[0]][position[1] + move[1]] if ((position[0] + move[0]).between?(0,7) && (position[1] + move[1]).between?(0,7))}.compact
        new_supported_piece = moves.select{|square| square.piece != nil && square.piece.side == 'white'} if side == 'white'
        new_supported_piece = moves.select{|square| square.piece != nil && square.piece.side == 'black'} if side == 'black'
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
    end
end

class Bishop
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :position, :supported, :supporting
    def initialize(side:, piece_symbol:, valid_moves: [], on_square:, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_bishop_moves(on_square)
    end

    def update_supporting_squares()
        old_supported_piece = supporting
        new_supported_piece = find_occupied_squares_diagonal(on_square).compact
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'white'} if side == 'white'
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'black'} if side == 'black'
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
    end
end

class Rook
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved, :position, :supported, :supporting
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_rook_moves(on_square)
    end

    def update_supporting_squares()
        old_supported_piece = supporting
        new_supported_piece = (find_occupied_squares_vertical(on_square) + find_occupied_squares_horizontal(on_square)).compact
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'white'} if side == 'white'
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'black'} if side == 'black'
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
    end
end

class Queen
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :position, :supported, :supporting
    def initialize(side:, piece_symbol:, valid_moves: [], on_square:, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
    end

    def update_valid_moves(on_square: @on_square)
        @valid_moves = find_valid_queen_moves(on_square)
    end

    def update_supporting_squares()
        old_supported_piece = supporting
        new_supported_piece = (find_occupied_squares_vertical(on_square) + find_occupied_squares_horizontal(on_square) + find_occupied_squares_diagonal(on_square)).compact
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'white'} if side == 'white'
        new_supported_piece = new_supported_piece.select{|square| square.piece != nil && square.piece.side == 'black'} if side == 'black'
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
    end
end

class King
    include PieceAction
    attr_accessor :side, :piece_symbol, :valid_moves, :on_square, :have_moved, :position, :supported, :supporting
    def initialize(side:, piece_symbol: ' ', valid_moves: [], on_square:, have_moved: 0, supported: 0, supporting: [])
        @side = side
        @piece_symbol = piece_symbol
        @on_square = on_square
        @position = on_square.position
        @have_moved = have_moved
        @valid_moves = valid_moves
        @supported = supported
        @supporting = supporting
    end

    def update_valid_moves(on_square: @on_square)
        if have_moved == 0
            @valid_moves = find_valid_king_moves(on_square)
            have_moved = 1
        else
            @valid_moves = find_valid_king_moves(on_square)
        end
    end

    def update_supporting_squares()
        old_supported_piece = supporting
        basic_moves = [[1,0],[1,1],[1,-1],[0,1],[0,-1],[-1,0],[-1,1],[-1,-1]]
        moves = basic_moves.map{|move| Board.board[position[0] + move[0]][position[1] + move[1]] if ((position[0] + move[0]).between?(0,7) && (position[1] + move[1]).between?(0,7))}.compact
        new_supported_piece = moves.select{|square| square.piece != nil && square.piece.side == 'white'} if side == 'white'
        new_supported_piece = moves.select{|square| square.piece != nil && square.piece.side == 'black'} if side == 'black'
        current = old_supported_piece & new_supported_piece
        (old_supported_piece - current).each{|position| position.piece.supported -= 1}
        (new_supported_piece - current).each{|position| position.piece.supported += 1}
        @supporting = new_supported_piece
    end
end

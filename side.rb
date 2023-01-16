require_relative 'action.rb'

class White
    include PieceAction, SquareAction
    @@pieces = []
    def initialize
        spawn_pawn('white')
        spawn_knight('white')
        spawn_bishop('white')
        spawn_rook('white')
        spawn_queen('white')
        spawn_king('white')
        @@pieces << Board.board[7][4].piece
        for i in 6..7
            for j in 0..7
                next if i == 7 && j == 4
                @@pieces << Board.board[i][j].piece
            end
        end
    end

    def self.pieces
        @@pieces
    end

    def update_piece(piece)
        @@pieces = piece
    end

    def short_castle
        move_to_new_square(get_square('e1'), get_square('g1'))
        move_to_new_square(get_square('h1'), get_square('f1'))
        White.pieces.each{|piece| piece.update_valid_moves}
        White.pieces.each{|piece| piece.update_supporting_squares}
    end

    def long_castle
        move_to_new_square(get_square('e1'), get_square('c1'))
        move_to_new_square(get_square('a1'), get_square('d1'))
        White.pieces.each{|piece| piece.update_valid_moves}
        White.pieces.each{|piece| piece.update_supporting_squares}
    end
end

class Black
    include PieceAction, SquareAction
    @@pieces = []
    def initialize
        spawn_pawn('black')
        spawn_knight('black')
        spawn_bishop('black')
        spawn_rook('black')
        spawn_queen('black')
        spawn_king('black')
        @@pieces << Board.board[0][4].piece
        for i in [1,0]
            for j in 0..7
                next if i == 0 && j ==4
                @@pieces << Board.board[i][j].piece
            end
        end
    end

    def self.pieces
        @@pieces
    end

    def update_piece(piece)
        @@pieces = piece
    end

    def short_castle
            move_to_new_square(get_square('e8'), get_square('g8'))
            move_to_new_square(get_square('h8'), get_square('f8'))
            Black.pieces.each{|piece| piece.update_valid_moves}
            Black.pieces.each{|piece| piece.update_supporting_squares}
    end

    def long_castle
            move_to_new_square(get_square('e8'), get_square('c8'))
            move_to_new_square(get_square('a8'), get_square('d8'))
            Black.pieces.each{|piece| piece.update_valid_moves}
            Black.pieces.each{|piece| piece.update_supporting_squares}
    end
end
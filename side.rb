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
end
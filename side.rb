require_relative 'action.rb'

class White
    attr_accessor :enpassant_pawn
    include PieceAction, SquareAction
    def initialize
        spawn_pawn('white')
        spawn_knight('white')
        spawn_bishop('white')
        spawn_rook('white')
        spawn_queen('white')
        spawn_king('white')
        @enpassant_pawn = []
    end
end

class Black
    attr_accessor :enpassant_pawn
    include PieceAction, SquareAction
    def initialize
        spawn_pawn('black')
        spawn_knight('black')
        spawn_bishop('black')
        spawn_rook('black')
        spawn_queen('black')
        spawn_king('black')
        @enpassant_pawn = []
    end
end
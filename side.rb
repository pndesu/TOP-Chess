require_relative 'action.rb'

class White
    include PieceAction, SquareAction
    def initialize
        spawn_pawn('white')
        spawn_knight('white')
        spawn_bishop('white')
        spawn_rook('white')
        spawn_queen('white')
        spawn_king('white')
    end
end

class Black
    include PieceAction, SquareAction
    def initialize
        spawn_pawn('black')
        spawn_knight('black')
        spawn_bishop('black')
        spawn_rook('black')
        spawn_queen('black')
        spawn_king('black')
    end
end
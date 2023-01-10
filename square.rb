require_relative 'board.rb'

class Square
    attr_accessor :color, :piece, :position, :notation
    def initialize(color:, piece: nil, position: [], notation: '') #Give more responsibility to piece class, piece class instance should have more attributes
        @color = color                                                                                              
        @piece = piece
        @position = position
        @notation = notation #Just for debugging and readability
    end

    def display_square
        return square_dark if color == 'dark'
        return square_white if color == 'white'
    end

    def square_dark
        (@piece == nil)? "\e[46m   \e[0m" : "\e[46m #{@piece.piece_symbol} \e[0m"
    end
    
    def square_white
        (@piece == nil)? "\e[47m   \e[0m" : "\e[47m #{@piece.piece_symbol} \e[0m"
    end
end
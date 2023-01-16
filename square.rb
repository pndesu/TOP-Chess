require_relative 'board.rb'

class Square
    attr_accessor :color, :piece, :position, :notation, :new_color
    def initialize(color:, piece: nil, position: [], notation: '', new_color: '') #Give more responsibility to piece class, piece class instance should have more attributes
        @color = color
        @new_color = color
        @piece = piece
        @position = position
        @notation = notation #Just for debugging and readability
    end

    def display_square
        return square_dark if new_color == 'dark'
        return square_white if new_color == 'white'
        return square_green if new_color == 'green'
        return square_red if new_color == 'red'
        return square_round if new_color == 'round'
    end

    def square_dark
        (@piece == nil)? "\e[46m   \e[0m" : "\e[46m #{@piece.piece_symbol} \e[0m"
    end
    
    def square_white
        (@piece == nil)? "\e[47m   \e[0m" : "\e[47m #{@piece.piece_symbol} \e[0m"
    end

    def square_green
        (@piece == nil)? "\e[42m   \e[0m" : "\e[42m #{@piece.piece_symbol} \e[0m"
    end

    def square_red
        "\e[41m #{@piece.piece_symbol} \e[0m"
    end

    def square_round
        return "\e[46m • \e[0m" if color == 'dark'
        return "\e[47m • \e[0m" if color == 'white'
    end
end
require_relative 'board.rb'

class Square
    attr_accessor :color, :piece, :side, :position, :valid_moves
    def initialize(color, piece = ' ', side = '', position = '', valid_moves = []) #Is position necessary?
        @color = color
        @piece = piece
        @side = side
        @position = position
        @valid_moves = valid_moves
    end

    def display_square
        return square_dark if color == 'dark'
        return square_white if color == 'white'
    end

    def update_piece(piece, side)
        @piece = piece
        @side = side
        display_square
    end

    def update_valid_moves(moves)
        @valid_moves = moves
    end

    def square_dark
        # "\u001b[48;5;95m #{@piece} \u001b[0m"
        "\e[46m #{@piece} \e[0m"
    end
    
    def square_white
        # "\u001b[48;5;223m #{@piece} \u001b[0m"
        "\e[47m #{@piece} \e[0m"
    end
end
module Action
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

    def move(position)

    end

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

class White
    include Action
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
    include Action
    def initialize
        spawn_pawn('black')
        spawn_knight('black')
        spawn_bishop('black')
        spawn_rook('black')
        spawn_queen('black')
        spawn_king('black')
    end
end


class Pawn
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♙'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♙', 'white')}
        else
            @symbol = '♟︎'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♟︎', 'black')}
        end
    end
end

class Knight
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♘'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♘', 'white')}
        else
            @symbol = '♞'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♞', 'black')}
        end
    end
end

class Bishop
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♗'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♗', 'white')}
        else
            @symbol = '♝'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♝', 'black')}
        end
    end
end

class Rook
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♖'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♖', 'white')}
        else
            @symbol = '♜'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♜', 'black')}
        end
    end
end

class Queen
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♕'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♕', 'white')}
        else
            @symbol = '♛'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♛', 'black')}
        end
    end
end

class King
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♔'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♔', 'white')}
        else
            @symbol = '♚'
            position.each{|square| Board.board[square[0]][square[1]].update_piece('♚', 'black')}
        end
    end
end

class Square
    attr_accessor :color, :piece, :side
    def initialize(color, piece = ' ', position = [], side = '') #Is position necessary?
        @color = color
        @piece = piece
        @side = side
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

    def square_dark
        # "\u001b[48;5;95m #{@piece} \u001b[0m"
        "\e[46m #{@piece} \e[0m"
    end
    
    def square_white
        # "\u001b[48;5;223m #{@piece} \u001b[0m"
        "\e[47m #{@piece} \e[0m"
    end
end

class Board
    attr_accessor :board
    @@board = []
    def self.board
        @@board
    end
    def reset_board
        for i in 0..7
            row = []
            for j in 0..7
                row << Square.new('white', ' ', [i,j]) if i.odd? && j.odd? #Position only used here
                row << Square.new('dark', ' ', [i,j]) if i.odd? && j.even?
                row << Square.new('white', ' ', [i,j]) if i.even? && j.even?
                row << Square.new('dark', ' ', [i,j]) if i.even? && j.odd?
            end
            @@board << row
        end
    end
    
    def display_board(board = @@board)
        board.each do |row|
            row.each do |square|
                print square.display_square
            end
            print "\n"
        end
    end
    
end

class Game
    def play
        board = Board.new
        board.reset_board
        white = White.new
        black = Black.new
        white.move_to_new_square('a2', 'a4')
        board.display_board
    end
end
Game.new.play

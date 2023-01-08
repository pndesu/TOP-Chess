require_relative 'board.rb'

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
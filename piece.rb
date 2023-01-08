require_relative 'board.rb'

class Pawn
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♙'
            position.each do |square|
                moves = [Board.board[square[0] - 1][square[1]], Board.board[square[0] - 2][square[1]]]
                Board.board[square[0]][square[1]].update_piece('♙', 'white')
                Board.board[square[0]][square[1]].update_valid_moves(moves)
            end
        else
            @symbol = '♟︎'
            position.each do |square|
                moves = [Board.board[square[0] + 1][square[1]], Board.board[square[0] + 2][square[1]]]
                Board.board[square[0]][square[1]].update_piece('♟︎', 'black')
                Board.board[square[0]][square[1]].update_valid_moves(moves)
            end
        end
    end
end

class Knight
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♘'
            position.each do |square|
                moves = [Board.board[square[0] - 2][square[1] - 1], Board.board[square[0] - 2][square[1] + 1]]
                Board.board[square[0]][square[1]].update_piece('♘', 'white')
                Board.board[square[0]][square[1]].update_valid_moves(moves)
            end
        else
            @symbol = '♞'
            position.each do |square|
                moves = [Board.board[square[0] + 2][square[1] - 1], Board.board[square[0] + 2][square[1] + 1]]
                Board.board[square[0]][square[1]].update_piece('♞', 'black')
                Board.board[square[0]][square[1]].update_valid_moves(moves)
            end
        end
    end
end

class Bishop
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♗'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♗', 'white')
            end
        else
            @symbol = '♝'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♝', 'black')
            end
        end
    end
end

class Rook
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♖'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♖', 'white')
            end
        else
            @symbol = '♜'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♜', 'black')
            end
        end
    end
end

class Queen
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♕'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♕', 'white')
            end
        else
            @symbol = '♛'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♛', 'black')
            end
        end
    end
end

class King
    def initialize(side, position = [])
        @side = side
        if side == 'white'
            @symbol = '♔'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♔', 'white')
            end
        else
            @symbol = '♚'
            position.each do |square|
                Board.board[square[0]][square[1]].update_piece('♚', 'black')
            end
        end
    end
end
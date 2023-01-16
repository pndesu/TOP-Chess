require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'
require 'yaml'

class Game
    attr_accessor :turn, :board, :white, :black
    include PieceAction, SquareAction, Display
    def play
        @board = Board.new
        @white = White.new
        @black = Black.new
        @board.display_board
        @turn = 0
        take_turn
    end

    def take_turn
        white_turn if turn % 2 == 0
        black_turn if turn % 2 == 1
    end

    def white_turn
        puts "White's turn"
        input = get_user_input('white')
        square = get_square(input[0])
        target_square = get_square(input[1])
        White.pieces.each{|piece| piece.update_valid_moves}
        File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces].to_yaml)}
        if square.piece.instance_of?(King) && (target_square.position[1] - square.position[1]).abs == 2 && check_castle_rights?('white', target_square)
            white.short_castle if square.position[1] < target_square.position[1]
            white.long_castle if square.position[1] > target_square.position[1]
        elsif (check_valid_side?(square, 'white') && check_valid_piece_move?(square, target_square))
            move_to_new_square(square, target_square) 
        else
            puts ErrorMessage('invalid_move')
            white_turn
        end
        Black.pieces.each{|piece| piece.update_valid_moves}
        if check?('white')
            reload_board
            white_turn
        else
            continue_board
            White.pieces.each{|piece| piece.update_valid_moves}
            White.pieces.each{|piece| piece.update_supporting_squares}
            board.display_board
            @turn += 1
            take_turn
        end
    end

    def black_turn
        puts "Black's turn"
        input = get_user_input('black')
        square = get_square(input[0])
        target_square = get_square(input[1])
        Black.pieces.each{|piece| piece.update_valid_moves}
        File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces].to_yaml)}
        if square.piece.instance_of?(King) && (target_square.position[1] - square.position[1]).abs == 2 && check_castle_rights?('black', target_square)
            black.short_castle if square.position[1] < target_square.position[1]
            black.long_castle if square.position[1] > target_square.position[1]
        elsif (check_valid_side?(square, 'black') && check_valid_piece_move?(square, target_square))
            move_to_new_square(square, target_square) 
        else
            puts ErrorMessage('invalid_move')
            black_turn
        end
        White.pieces.each{|piece| piece.update_valid_moves}
        if check?('black')
            reload_board
            black_turn
        else
            continue_board
            Black.pieces.each{|piece| piece.update_valid_moves}
            Black.pieces.each{|piece| piece.update_supporting_squares}
            board.display_board
            @turn += 1
            take_turn
        end
    end
    
    def get_user_input(side)
        arr = []
        loop do
            print 'Enter square: '
            input = gets.chomp
            if input.match(/^[a-h][1-8]$/) && get_square(input).piece != nil && get_square(input).piece.side == side
                arr << input
                break 
            end
            puts ErrorMessage('invalid_input')
        end
        loop do
            print 'Enter destination square: '
            target_input = gets.chomp
            if target_input.match(/^[a-h][1-8]$/)
                arr << target_input 
                break 
            end
            puts ErrorMessage('invalid_input')
        end
        arr
    end

    def reload_board
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        board.update_board(old_board[0])
        white.update_piece(old_board[1])
        black.update_piece(old_board[2])
        puts ErrorMessage('invalid_move')
    end

    def continue_board
        new_board = Board.board
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        check_board_for_enpassant(old_board[0], new_board)
    end
end
Game.new.play


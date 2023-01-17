require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'
require_relative 'move_logic.rb'
require 'yaml'

class HumanVsComputer
    attr_accessor :turn, :board, :white, :black, :last_move, :filename
    include PieceAction, SquareAction, Display, MoveLogic
    def initialize
        @filename = nil
        @board = Board.new
        @white = White.new
        @black = Black.new
        @board.display_board
        @turn = 0
        @last_move = []
        @storage = [Board.board, White.pieces, Black.pieces, @last_move]
        take_turn
    end

    def black_turn
        puts "Black's turn"
        Black.pieces.each{|piece| piece.update_valid_moves}
        File.open("old_board", "w"){|file| Marshal.dump([Board.board, White.pieces, Black.pieces, @last_move], file)}
        last_move.each{|move| change_square_color(move, move.color)} if last_move.length != 0
        moveable_pieces = Black.pieces.select{|piece| piece.valid_moves.length > 0}
        square = moveable_pieces.sample.on_square
        target_square = square.piece.valid_moves.sample
        if square.piece.instance_of?(King) && (target_square.position[1] - square.position[1]).abs == 2 && check_castle_rights?('black', target_square)
            black.short_castle if square.position[1] < target_square.position[1]
            black.long_castle if square.position[1] > target_square.position[1]
        else
            move_to_new_square(square, target_square)
        end
        White.pieces.each{|piece| piece.update_valid_moves}
        if check?('black')
            reload_board
            board.display_board
            black_turn
        else
            @last_move = [square, target_square]
            change_square_color(square, 'green')
            change_square_color(target_square, 'green')
            Black.pieces.each{|piece| piece.update_valid_moves}
            Black.pieces.each{|piece| piece.update_supporting_squares}
            @storage[0] = Board.board

            continue_board
            board.display_board
            White.pieces.each{|piece| piece.update_valid_moves}
            if checkmate?('white')
                File.delete("./saved_games/#{@filename}") if @filename != nil
                puts "Checkmate! Black won!"
                continue_playing
            end
            @turn += 1
            take_turn
        end
    end
end

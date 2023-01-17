require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'
require_relative 'move_logic.rb'
require 'yaml'

class HumanVsHuman
    attr_accessor :turn, :board, :white, :black, :last_move, :filename
    include PieceAction, SquareAction, Display, MoveLogic
    def initialize
        @board = Board.new
        @white = White.new
        @black = Black.new
        @filename = nil
        @board.display_board
        @turn = 0
        @last_move = []
        @storage = [Board.board, White.pieces, Black.pieces, @last_move]
        take_turn
    end
end


require_relative 'action.rb'
require_relative 'board.rb'
require_relative 'square.rb'
require_relative 'side.rb'
require_relative 'piece.rb'
require_relative 'display.rb'
require_relative 'serializer.rb'

module MoveLogic
    include Serializer
    def play
        @board.update_board(@storage[0]) 
        @white.update_piece(@storage[1])
        @black.update_piece(@storage[2])
        @last_move = @storage[3]
        @board.display_board
        take_turn
    end

    def take_turn
        white_turn if turn % 2 == 0
        black_turn if turn % 2 == 1
    end

    def white_turn
        White.pieces.each{|piece| piece.update_valid_moves}
        if checkmate?('white')
            File.delete("./saved_games/#{filename}.yaml") if File.exist?("./saved_games/#{filename}.yaml")
            puts "Checkmate! Black won!"
            exit
        end

        puts "White's turn"
        File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces].to_yaml)}
        last_move.each{|move| change_square_color(move, move.color)} if last_move.length != 0
        input = get_user_input('white')
        square = get_square(input[0])
        target_square = get_square(input[1])
        if square.piece.instance_of?(King) && (target_square.position[1] - square.position[1]).abs == 2 && check_castle_rights?('white', target_square)
            white.short_castle if square.position[1] < target_square.position[1]
            white.long_castle if square.position[1] > target_square.position[1]
        else
            move_to_new_square(square, target_square)
        end
        Black.pieces.each{|piece| piece.update_valid_moves}
        if check?('white')
            reload_board
            board.display_board
            white_turn
        else
            @last_move = [square, target_square]
            change_square_color(target_square, 'green')
            White.pieces.each{|piece| piece.update_valid_moves}
            White.pieces.each{|piece| piece.update_supporting_squares}
            
            continue_board
            board.display_board
            @turn += 1
            take_turn
        end
    end

    def black_turn
        Black.pieces.each{|piece| piece.update_valid_moves}
        if checkmate?('black')
            File.delete("./saved_games/#{filename}") if File.exist?("./saved_games/#{filename}")
            puts "Checkmate! White won!"
            exit
        end

        puts "Black's turn"
        File.open("old_board.yml", "w"){|file| file.write([Board.board, White.pieces, Black.pieces, @last_move].to_yaml)}
        last_move.each{|move| change_square_color(move, move.color)} if last_move.length != 0
        input = get_user_input('black')
        square = get_square(input[0])
        target_square = get_square(input[1])
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
            change_square_color(target_square, 'green')
            Black.pieces.each{|piece| piece.update_valid_moves}
            Black.pieces.each{|piece| piece.update_supporting_squares}
            
            continue_board
            board.display_board
            @turn += 1
            take_turn
        end
    end
    
    def get_user_input(side) #Get user input and change square color
        arr = []
        loop do
            puts 'Press [s] to save game, [q] to quit.'
            print 'Enter square: '
            input = gets.chomp
            save if input == 's'
            exit if input == 'q'
            if input.match(/^[a-h][1-8]$/) && get_square(input).piece != nil && get_square(input).piece.side == side && get_square(input).piece.valid_moves.length > 0
                arr << input
                break 
            end
            puts ErrorMessage('invalid_input')
        end
        change_square_color(get_square(arr[0]), 'green')
        change_valid_move_squares_color(get_square(arr[0]), 'on')
        board.display_board
        loop do
            print 'Enter destination square: '
            target_input = gets.chomp
            if target_input.match(/^[a-h][1-8]$/) && get_square(arr[0]).piece.valid_moves.include?(get_square(target_input))
                arr << target_input 
                break 
            end
            puts ErrorMessage('invalid_input')
        end
        change_valid_move_squares_color(get_square(arr[0]), 'off')
        arr
    end

    def reload_board
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        board.update_board(old_board[0])
        white.update_piece(old_board[1])
        black.update_piece(old_board[2])
        @last_move = old_board[3]
        puts ErrorMessage('invalid_move')
    end

    def continue_board
        new_board = Board.board
        old_board = Psych.unsafe_load(File.read("old_board.yml"))
        check_board_for_enpassant(old_board[0], new_board)
    end
end
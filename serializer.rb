require_relative 'display.rb'
require_relative 'game.rb'
require 'yaml'

module Serializer
    include PieceAction, SquareAction, Display

    def save
        Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
        folder = Dir.glob("saved_games/*")
        File.delete("./saved_games/#{@filename}") if @filename != nil
        filename = create_filename
        File.open("./saved_games/#{filename}", 'w'){|file| file.puts(Marshal.dump(self, file))}
        continue_playing
    end

    def create_filename
        date = Time.now.strftime('%Y-%m-%d').to_s
        time = Time.now.strftime('%H:%M:%S').to_s
        "Chess #{date} at #{time}"
    end

    def load
        folder = create_name_list
        loop do
            print "Select a game: "
            input = gets.chomp.to_i
            puts ""
            if (input.between?(1, folder.length))
                saved_game = Marshal.load(File.read("./saved_games/#{folder[input - 1]}"))
                saved_game.filename = folder[input - 1]
                saved_game.play
            end
            puts ErrorMessage('file_error')
        end
    end

    def create_name_list
        folder = Dir.glob("saved_games/*")
        name_list = []
        if (folder.length == 0)
            puts "There is no saved game."
            continue_playing()
        else
            puts "Saved games: "
            folder.each_with_index do |name, index| 
                puts "#{index + 1}. #{name.split("/")[1]}"
                name_list << name.split("/")[1]
            end
        end
        name_list
    end

    def continue_playing
        Board.reset_board
        White.reset_pieces
        Black.reset_pieces

        print "Press [y] to continue playing: "
        input = gets.chomp.downcase
        if input == 'y'
            Game.new.play
        else
            exit
        end
    end
end
require_relative 'human_vs_computer.rb'
require_relative 'human_vs_human.rb'
require_relative 'display.rb'
require_relative 'serializer.rb'

class Game
    include Display, Serializer
    def play
        puts WelcomeMessage()
        loop do
            input = gets.chomp
            mode_choice(input) if input.match(/^[1-3]$/)
            puts ErrorMessage('invalid_input')
        end
    end

    def mode_choice(input)
        case input
            when '1' then HumanVsComputer.new
            when '2' then HumanVsHuman.new
            when '3' then load
        end
    end
end

Game.new.play
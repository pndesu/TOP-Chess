module Display
    def ErrorMessage(message)
        {
            'invalid_move' => "Please enter a valid move!",
            'invalid_input' => "Please enter a valid input!",
            'file_error' => "Please select a valid file"
        }[message]
    end

    def WelcomeMessage()
        <<-HEREDOC
Welcome to Chess!

Each turn will be played in two different steps.

Step One:
Enter the coordinates of the piece you want to move.

Step Two:
Enter the coordinates of any legal move or capture.


To begin, enter one of the following to play:
    [1] to play a new 1-player game against the computer
    [2] to play a new 2-player game
    [3] to play a saved game 
        HEREDOC
    end
end
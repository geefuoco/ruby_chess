require "colorize"

module GameMessage

  def display_welcome
    puts <<~'HEREDOC'
     ______     __  __     ______     ______     ______    
    /\  ___\   /\ \_\ \   /\  ___\   /\  ___\   /\  ___\   
    \ \ \____  \ \  __ \  \ \  __\   \ \___  \  \ \___  \  
     \ \_____\  \ \_\ \_\  \ \_____\  \/\_____\  \/\_____\ 
      \/_____/   \/_/\/_/   \/_____/   \/_____/   \/_____/ 
                                                                                                                
    HEREDOC
    .green
    puts <<~HEREDOC
    Please choose from the options below

    \e[33mPress 1 to start a new game\e[0m
    \e[34mPress 2 to load a saved game\e[0m


    HEREDOC
  end

  def display_turn
    puts <<~HEREDOC
    #{@players.first.capitalize} to play.

    Enter a position on the board to select that piece.

    \e[33mTo save the game, enter 'save game'\e[0m
    \e[35mTo resign, enter 'resign'\e[0m
    HEREDOC

  end

  def display_no_piece_warning
    puts <<~HEREDOC
    \e[35mWARNING: There is not piece on that square.\e[0m

    Please select a position that has a piece on it.
    HEREDOC
  end
  
  def display_wrong_piece_warning
    puts <<~HEREDOC
    \e[35mWARNING: The selected piece belongs to your opponent.\e[0m

    Please select a position that has your own piece on it.
    HEREDOC
  end

  def display_no_move_warning
    puts <<~HEREDOC
    \e[35mWARNING: The selected piece does not have that move available.\e[0m

    Please select a legal move on the board.
    HEREDOC
  end

  def display_check_warning
    puts <<~HEREDOC
    WARNING: CHECK
    HEREDOC
    .red
  end

  def display_cannot_move_in_check_warning
    puts <<~HEREDOC
    \e[35mWARNING: You cannot do that while in check.\e[0m

      Please select a legal move on the board.
    HEREDOC
  end

  def display_game_end
    puts <<~HEREDOC
    Checkmate

    #{@players.last} is the winner.
    HEREDOC
    .green
  end

  def display_moves(array_of_moves)
    moves = array_of_moves.map { |mv| @reversed[mv.goal_position] }
    puts "Select from the moves below"
    p moves
  end

  def display_resignation(player_that_resigned)
    puts <<~HEREDOC
    #{player_that_resigned} has resigned

    GAME OVER
    HEREDOC
    .green
  end

  def display_stalemate
    puts <<~HEREDOC
    Stalemate.

    GAMEOVER
    HEREDOC

  end

  def display_draw
    puts <<~HEREDOC

    The game has ended in a draw

    GAMEOVER

    HEREDOC
  end

  def display_no_games_found
    puts <<~HEREDOC
    No games were found in the saved games folder.

    Starting new game...
    HEREDOC
  end

end
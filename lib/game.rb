require_relative "./game_message.rb"

class Game

  include GameMessage

  def initialize(game_board)
    @game_board = game_board
    @players = ["white", "black"]
    @coordinates = game_board.generate_coordinate_map()
    @reversed = game_board.generate_coordinate_map().invert
    @full_moves = 1
    @half_moves = 0
    @board_positions = {}
  end

  def start
    display_welcome()
    get_game()
    while !game_over?()
      @game_board.print_board
      return display_stalemate() if @game_board.stalemate?(@players.first)
      return display_reptition_draw() if repition_draw?()
      return display_fifty_move_draw() if fifty_move_draw?()
      return if @saved
      return display_resignation(@resign) if @resign
      game_turn()
    end
    @game_board.print_board
    display_game_end
  end

  def get_game(input=nil)
    while (input !="1" || input != "2") do
      input = gets.chomp
      return new_game() if input == "1"
      return load if input == "2"
    end
  end

  def new_game
    @game_board.convert_fen(@game_board.class::START)
  end

  def load
    if Dir.exist?("saved_games")
      return load_save_directory()
    end
    return new_game()
  end

  def load_save_directory
    if Dir.empty?("saved_games")
      display_no_games_found()
      return new_game() 
    end
    display_saved_games()
    read_save_file()
  end

  def read_save_file
    input = gets.chomp
    return load if !(/\d/ === input)
    if Dir.children("saved_games")[input.to_i].nil?
      puts "Please only select from the available options"
      return load 
    end
    save_file = Dir.children("saved_games")[input.to_i]
    load_file(save_file)
  end

  def load_file(save_file)
    File.open("saved_games/#{save_file}", "r") { |file| 
      return load_game_from_fen(file.read)
    }
  end

  def load_game_from_fen(fen_string)
    map = @game_board.convert_fen(fen_string)
    puts map[:player] == @players.first
    if !(map[:player] == @players.first)
      swap_players()
    end
    @full_moves = map[:full_moves].to_i
    @half_moves = map[:half_moves].to_i
  end

  def save
    @save = "saved"
    if !Dir.exist?("saved_games")
      Dir.mkdir("saved_games")
    end
    filename = "saved_games/game #{Dir.children("saved_games").length}"
    File.open(filename, "w") do |file|
      player = @players.first
      file.write(@game_board.convert_to_fen(player, @half_moves, @full_moves))
    end
    return true
  end

  def resign
    @resign = @players.first
    return true
  end

  def game_turn
    display_turn()
    display_check_warning() if @game_board.check?()
    legal_move = execute_player_move()
    if legal_move.nil?
      @game_board.print_board
      return game_turn() 
    end
    @game_board.reset_passable_pawns(@players.first)
    swap_players()
    increment_moves()
    puts `clear`
    add_board_position()
  end

  def add_board_position
    key = @game_board.convert_to_fen(@players.first, @half_moves, @full_moves)
    components = key.split(" ")
    pieces = components.first
    if @board_positions.keys.include?(pieces)
      @board_positions[pieces] += 1
    else
      @board_positions[pieces] = 1
    end
  end
  
  def repition_draw?
    @board_positions.values.any? { |v| v > 2 }
  end

  def fifty_move_draw?
    @half_moves/2 > 49
  end

  def execute_player_move
    piece = get_player_selection()
    return save() if piece == "save game"
    return resign() if piece == "resign"
    return display_no_piece_warning() if !piece.respond_to?(:get_legal_moves)
    moves = piece.get_legal_moves
    display_moves(moves)
    move = get_move_from_input(moves)
    return display_no_move_warning() if move.nil?
    move_object = moves.select { |mv| mv.goal_position == move }.first
    return display_no_move_warning() if !moves.include?(move_object)
    return display_cannot_move_in_check_warning() if !valid_move?(piece, move_object)
    process_half_moves(piece, move_object)
    @game_board.execute_move(piece, move_object)
    return true
  end

  def get_player_selection
    selection = gets.chomp
    begin 
      piece = @game_board.get_piece(@coordinates[selection])
      return display_wrong_piece_warning() if piece.color != @players.first
      @game_board.select_piece(piece)
    rescue => e
      return selection
    end
    return piece
  end

  def valid_move?(piece, move)
    @game_board.valid_piece_move?(piece, move.goal_position)
  end

  def get_move_from_input(moves)
    input = gets.chomp
    move = @coordinates[input] || nil
  end

  def swap_players
    @players.rotate!
  end

  def game_over?
    @game_board.checkmate?
  end

  def increment_moves
    if @players.first == "white"
      @full_moves += 1
    end
  end

  def process_half_moves(piece, move_object)
    if piece.class == Pawn || move_object.class == CaptureMove
      @half_moves = 0
    else
      @half_moves += 1
    end
  end

end
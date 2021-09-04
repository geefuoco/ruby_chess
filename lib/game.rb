require_relative "./game_message.rb"

class Game

  include GameMessage

  def initialize(game_board)
    @game_board = game_board
    @players = ["white", "black"]
    @coordinates = generate_coordinate_map()
    @reversed = generate_coordinate_map().invert
  end

  def generate_coordinate_map
    coordinates = {}
    rank = 1
    files = "abcdefgh"
    7.downto(0) do |n|
      8.times do |m|
        coordinates["#{files[m]}#{rank}"] = [n, m]
      end
      rank += 1
    end
    return coordinates
  end

  def start
    display_welcome()
    get_game()
    while !game_over?()
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

  end

  def save
    @save = "saved"

    return true
  end

  def resign
    @resign = @players.first
    return true
  end

  def game_turn
    @game_board.print_board
    display_turn()
    display_check_warning() if @game_board.check?()
    legal_move = execute_player_move()
    return game_turn() if legal_move.nil?
    @game_board.reset_passable_pawns(@players.first)
    swap_players()
    puts `clear`
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

end
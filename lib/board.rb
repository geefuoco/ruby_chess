require_relative "./tile"
require_relative "./forsyth_edwards_notation"
require_relative "./board_displayer"
require_relative "./board_util"

class Board

  include BoardUtil
  include BoardDisplayer
  include ForsythEdwardsNotation

  FILES = 8
  RANKS = 8
  START = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  def initialize
    @board = create_board
  end

  def create_board
    board = []
    RANKS.times do |n|
      board[n] = []
      FILES.times do |m|
        board[n][m] = Tile.new(n, m)
      end
    end
    return board
  end

  def checkmate?
    check?() &&
    king_no_moves?() && 
   !can_capture_checker?() && 
   !can_block_checker?()
  end

  def stalemate?(color)
    !check?() &&
    no_legal_moves(color)
  end

  def no_legal_moves(color)
    get_all_legal_moves(color).empty? 
  end

  def get_all_legal_moves(color)  
    moves = []
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          if piece.color == color
            legal_moves = piece.get_legal_moves
            legal_moves.each { |mv| moves << mv if valid_piece_move?(piece, mv.goal_position)}
          end
        rescue => exception
        end
      end
    end
    moves.flatten
  end

  def king_no_moves?
    get_checked_king().get_legal_moves.empty?
  end

  def can_capture_checker?
    pieces = get_pieces_attacking_king()
    pieces.any? { |piece| piece_can_be_captured?(piece) }
  end

  def can_block_checker?
    can_block_check?()
  end

  def valid_piece_move?(piece_to_move, new_position)
    begin
      old_piece = get_piece(new_position)
    rescue => e
    end
    old_position = piece_to_move.position_coordinates
    set_piece(piece_to_move, new_position)
    remove_piece(old_position)
    valid_move = true
    if check?()
      king = get_checked_king()
      if king.color == piece_to_move.color
        valid_move = false
      end
    end
    revert_piece_positions(old_piece, new_position)
    set_piece(piece_to_move, old_position)
    return valid_move
  end

  def revert_piece_positions(old_piece, new_position)
    if old_piece
      set_piece(old_piece, new_position)
    else
      remove_piece(new_position)
    end
  end

  def check?
    @board.any? do |rank|
      rank.any? do |tile|
        begin
          piece = get_piece(tile.position)
          next if piece.class == King
          piece.get_legal_moves.any? do |mv|
            (mv.class == CaptureMove &&  
            mv.attacked_piece.class == King &&
            mv.attacked_piece.color != piece.color) ||
            (mv.class == PromotionMove &&
            get_piece(mv.goal_position).class == King &&
            get_piece(mv.goal_position).color != piece.color)
          end
        rescue => e
        end 
      end
    end
  end

  def get_checked_king
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          next if piece.class == King
          piece.get_legal_moves.each do |mv|
            if mv.class == CaptureMove &&  
               mv.attacked_piece.class == King &&
               mv.attacked_piece.color != piece.color
               return mv.attacked_piece
            end
            if mv.class == PromotionMove &&
              get_piece(mv.goal_position).class == King &&
              get_piece(mv.goal_position).color != piece.color
              return get_piece(mv.goal_position)
            end
          end
        rescue => e
        end 
      end
    end
    return nil
  end

  def get_pieces_attacking_king
    attacking_king = []
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          next if piece.class == King
          piece.get_legal_moves.each do |mv|
            if mv.class == CaptureMove &&  
               mv.attacked_piece.class == King &&
               mv.attacked_piece.color != piece.color
               attacking_king << piece
            end
            if mv.class == PromotionMove &&
              get_piece(mv.goal_position).class == King &&
              get_piece(mv.goal_position).color != piece.color
              attacking_king << piece
            end
          end
        rescue => e
        end 
      end
    end
    return attacking_king
  end

  def piece_can_be_captured?(piece)
    @board.any? do |rank|
      rank.any? do |tile|
        begin 
          attack_piece = get_piece(tile.position)
          attack_piece.get_legal_moves.any? do |mv|
            (mv.class == CaptureMove && 
            mv.attacked_piece == piece) ||
            (mv.class == PromotionMove &&
            get_piece(mv.goal_position) == piece)
          end
        rescue =>e
        end
      end
    end
  end

  def can_block_check?
    king = get_checked_king()
    @board.any? do |rank|
      rank.any? do |tile|
        begin 
          piece = get_piece(tile.position)
          next if piece.color != king.color
          piece.get_legal_moves.any? do |mv|
            valid_piece_move?(piece, mv.goal_position)
          end
        rescue => e 
        end
      end
    end
  end
    
  def execute_move(piece, move)
    case
    when move.class == CastleMove
      castle_move(piece, move)
    when move.class == PromotionMove
      promotion_move(piece, move)
    when move.class == CaptureMove
      capture_move(piece, move)
    else
      normal_move(piece, move)
    end
  end

  def promotion_move(piece, move)
    normal_move(piece, move)
    puts "Select a piece to promote to"
    puts "[q] Queen, [r] Rook, [b] Bishop, [n] Knight"
    input = gets.chomp
    validate_promotion(input)
    if piece.color == "white"
      input.capitalize!
    end
    set_promoted_piece(input, move.goal_position)
  end

  def set_promoted_piece(input, position_coordinates)
    piece = piece_selector(input, position_coordinates)
    set_piece(piece, position_coordinates)
  end

  def validate_promotion(input)
    while !valid_input(input) do
      validate_promotion(gets.chomp)
    end
  end

  def valid_input(input)
    input == "q" || input == "r" || 
    input == "n" || input == "b"  
  end

  def castle_move(piece, move)
    normal_move(piece, move)
    rook = move.rook
    normal_move(rook, move.rook_move)
  end

  def capture_move(piece, move)
    target_position = move.attacked_piece.position_coordinates
    remove_piece(target_position)
    normal_move(piece, move)
  end


  def normal_move(piece, move)
    start_position = piece.position_coordinates
    start_tile = get_tile(start_position)
    start_tile.remove_piece
    new_tile = get_tile(move.goal_position)
    new_tile.set_piece(piece)
    piece.move(move)
  end

  def reset_passable_pawns(color)
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          if piece.class == Pawn && piece.color != color
            piece.make_unpassable
          end
        rescue => e
        end
      end
    end
  end

  def position_occupied?(position_coordinate)
    return get_tile(position_coordinate).occupied?
  end

  def get_piece(position_coordinates)
    return get_tile(position_coordinates).get_piece
  end

  def set_piece(piece, position_coordinates)
    tile = get_tile(position_coordinates)
    tile.set_piece(piece)
  end

  def remove_piece(position_coordinates)
    tile = get_tile(position_coordinates)
    tile.remove_piece
  end

  def get_tile(position_coordinates)
    rank_index = position_coordinates[0]
    file_index = position_coordinates[1]
    return @board[rank_index][file_index]
  end

  def set_tile(tile, position_coordinates)
    rank_index = position_coordinates[0]
    file_index = position_coordinates[1]
    @board[rank_index][file_index] = tile
  end

  def select_piece(piece)
    @selected_piece = piece
  end

end
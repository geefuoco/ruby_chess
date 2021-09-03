require "observer"
require_relative "./tile"
require_relative "./forsyth_edwards_notation"
require_relative "./board_displayer"

class Board

  include Observable
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

  def execute_move()

  end

  def checkmate?
    check?() &&
    king_no_moves?() && 
   !can_capture_checker?() && 
   !can_block_checker?()
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
    is_check = check?()
    revert_piece_positions(old_piece, new_position)
    set_piece(piece_to_move, old_position)
    return !is_check
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
            mv.class == CaptureMove &&  
            mv.attacked_piece.class == King &&
            mv.attacked_piece.color != piece.color
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
            mv.class == CaptureMove && 
            mv.attacked_piece == piece
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
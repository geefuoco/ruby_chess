require "observer"
require_relative "./tile"
require_relative "./forsyth_edwards_notation"

class Board

  include Observable
  include ForsythEdwardsNotation

  FILES = 8
  RANKS = 8

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

  def get_pieces_attacking_position(position_coordinates)
    attacking_pieces = []
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          bool = piece.get_legal_moves
               .map { |mv| mv.goal_position}
               .include?(position_coordinates)
          attacking_pieces << piece if bool
        rescue ChessExceptions::NoPieceError
        end 
      end
    end
  end

end
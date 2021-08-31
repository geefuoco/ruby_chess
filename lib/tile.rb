
class Tile
  attr_reader :rank_index, :file_index, :position, :piece
  def initialize(rank_index, file_index, piece=nil)
    @rank_index = rank_index
    @file_index = file_index
    @position = [rank_index, file_index]
    @piece = piece
  end

  def get_piece
    raise ChessExceptions::NoPieceError if !occupied?
    return @piece
  end

  def occupied?
    return !@piece.nil?
  end

  def set_piece(piece)
    @piece = piece
  end

  def remove_piece
    @piece = nil
  end

end
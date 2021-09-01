require_relative "../move_validator"

class AbstractPiece

  include MoveValidator

  attr_reader :color, :position_coordinates, :board

  def initialize(color, position_coordinates, board)
    @color = color
    @position_coordinates = position_coordinates
    @moved = false
    @legal_moves = {}
    @board = board
    board.add_observer(self)
  end

  def get_legal_moves
    rank_index = @position_coordinates[0]
    file_index = @position_coordinates[1]
    create_moves(rank_index, file_index)
  end

  def create_moves(rank_offset, file_offset)
    raise ChessExceptions::BaseClassError
  end

  def update

  end

end
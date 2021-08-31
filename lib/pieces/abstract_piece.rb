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
    raise ChessExceptions::BaseClassError
  end

  def update

  end

end
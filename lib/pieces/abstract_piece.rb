require_relative "../move_validator"

class AbstractPiece

  include MoveValidator

  attr_reader :color, :position_coordinates, :board, :moved

  def initialize(color, position_coordinates, board)
    @color = color
    @position_coordinates = position_coordinates
    @moved = false
    @legal_moves = {}
    @board = board
  end

  def get_legal_moves
    rank_index = @position_coordinates[0]
    file_index = @position_coordinates[1]
    create_moves(rank_index, file_index)
  end

  def create_moves(rank_index, file_index)
    raise ChessExceptions::BaseClassError
  end

  def move(move_object)
    @position_coordinates = move_object.goal_position
    @moved = true
  end

  def code
    color == "white" ? self.class::WHITE : self.class::BLACK
  end

end
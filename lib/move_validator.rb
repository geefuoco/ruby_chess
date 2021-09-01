require_relative "./moves/normal_move"
require_relative "./moves/capture_move"

module MoveValidator

  def create_move(new_position)
    case
    when has_enemy_piece?(new_position)
      attacked_piece = self.board.get_piece(new_position)
      return CaptureMove.new(new_position, attacked_piece)
    when normal_move?(new_position)
      return NormalMove.new(new_position)
    end
  end

  def outside_of_board(position_coordinates)
    return position_coordinates.any? { |el| el<0 || el>7 }
  end

  def has_piece?(new_position)
    self.board.position_occupied?(new_position)
  end

  def has_friendly_piece?(new_position)
    self.board.position_occupied?(new_position) &&
    self.board.get_piece(new_position).color == self.color
  end

  def has_enemy_piece?(new_position)
    self.board.position_occupied?(new_position) &&
    self.board.get_piece(new_position).color != self.color
  end

  def normal_move?(new_position)
    !outside_of_board(new_position) && 
    !self.board.position_occupied?(new_position)
  end

end
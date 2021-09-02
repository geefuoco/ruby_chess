require_relative "./abstract_move"

class CaptureMove < AbstractMove
  attr_reader :attacked_piece
  def initialize(goal_position, attacked_piece)
    super(goal_position)
    @attacked_piece = attacked_piece
  end

end
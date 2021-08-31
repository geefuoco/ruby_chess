require_relative "./abstract_move"

class CaptureMove < AbstractMove

  def initialize(goal_position, attacked_piece)
    super(goal_position)
    @piece = piece
  end
  

end
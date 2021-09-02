require_relative "./abstract_move"

class CastleMove < AbstractMove


  def initialize(goal_position, rook)
    super(goal_position)
    @rook = rook
  end

end
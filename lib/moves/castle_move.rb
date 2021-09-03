require_relative "./abstract_move"

class CastleMove < AbstractMove

  attr_reader :rook, :rook_move
  def initialize(goal_position, rook, rook_move)
    super(goal_position)
    @rook = rook
    @rook_move = rook_move
  end

end
require_relative "./abstract_move"

class PromotionMove < AbstractMove

  def initialize(goal_position, attacked_piece=nil)
    super(goal_position)
    @attacked_piece = attacked_piece
  end

end
class AbstractMove
  
  attr_reader :goal_position
  def initialize(position_coordinates)
    @goal_position = position_coordinates
  end

end
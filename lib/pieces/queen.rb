require_relative "./sliding_piece"

class Queen < SlidingPiece

  MOVE_SET = [[1, 0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

end


require_relative "./sliding_piece"

class Bishop < SlidingPiece

  MOVE_SET = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  BLACK = "\u265D"
  WHITE = "\u2657"

end
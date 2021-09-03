require_relative "./sliding_piece"

class Rook < SlidingPiece

  MOVE_SET = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  BLACK = "\u265C"
  WHITE = "\u2656"

end

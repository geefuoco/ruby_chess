require_relative "./abstract_piece"

class Pawn < AbstractPiece

  def create_moves(rank_index, file_index)
    moves = []
    moves << AbstractMove.new("")
    return moves.compact
  end

  def direction
    d = color == "white" ? -1 : 1
    return d
  end
end
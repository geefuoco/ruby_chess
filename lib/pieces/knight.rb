require_relative "./abstract_piece" 

class Knight < AbstractPiece

  MOVE_SET = [[-1, -2], [-1, 2], [1, -2], [1, 2],
              [-2, -1], [-2, 1], [2, -1], [2, 1]]


  def create_moves(rank_index, file_index)
    moves = []
    MOVE_SET.each do |move_set|
      rank_offset = rank_index + move_set[0]
      file_offset = file_index + move_set[1]
      new_position = [rank_offset, file_offset]
      next if outside_of_board?(new_position)
      moves << create_move(new_position)
    end
    return moves.compact
  end




end
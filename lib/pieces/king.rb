require_relative "./abstract_piece"

class King < AbstractPiece

  MOVE_SET = [[1, 0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]


  def create_moves(rank_index, file_index)
    moves = []
    MOVE_SET.each do |move_set| 
      rank_offset = rank_index + move_set[0]
      file_offset = file_index + move_set[1]
      new_position = [rank_offset, file_offset]
      moves << create_move(new_position)
    end
    moves.compact
  end

end
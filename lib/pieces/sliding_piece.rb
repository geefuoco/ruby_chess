require_relative "./abstract_piece"

class SlidingPiece < AbstractPiece

  def create_moves(rank_index, file_index)
    moves = []
    self.class::MOVE_SET.each do |move_set|
      rank_offset = rank_index + move_set[0]
      file_offset = file_index + move_set[1]
      new_position = [rank_offset, file_offset]
      add_sliding_moves(new_position, move_set, moves)
    end
    return moves.compact
  end

  def add_sliding_moves(new_position, move_set, moves)
    while !outside_of_board?(new_position)
      moves << create_move(new_position)
      break if has_piece?(new_position)
      rank_offset = move_set[0] + new_position[0]
      file_offset = move_set[1] + new_position[1]
      new_position = [rank_offset, file_offset] 
    end
  end
  
end
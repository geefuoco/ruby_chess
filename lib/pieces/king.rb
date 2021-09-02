require_relative "./abstract_piece"

class King < AbstractPiece

  MOVE_SET = [[1, 0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  SPECIAL_MOVE = [[0, -2], [0, 2]]

  def create_moves(rank_index, file_index)
    moves = []
    generate_moves(moves, rank_index, file_index)
    moves.compact
  end

  def generate_moves(moves, rank_index, file_index)
    MOVE_SET.each do |move_set| 
      rank_offset = rank_index + move_set[0]
      file_offset = file_index + move_set[1]
      new_position = [rank_offset, file_offset]
      moves << create_move(new_position)
    end
  end

  def generate_special_moves(moves, rank_index, file_index)
    SPECIAL_MOVE.each do |move_set|
      rank_offset = rank_index + move_set[0]
      file_offset = file_index + move_set[1]
      new_position = [rank_offset, file_offset]
      side_position = [rank_index, (file_offset-file_index)/2]
      castle_position = [rank_index, file_offset]
      moves << create_castle_move(new_position, side_position, castle_position)
    end
  end

end
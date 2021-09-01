require_relative "./abstract_piece"

class Pawn < AbstractPiece

  MOVE_SET = [1, 0]
  SPECIAL_MOVE = [2, 0]
  CAPTURE_SET = [[1, 1], [1, -1]]

  def create_moves(rank_index, file_index)
    moves = []
    generate_normal_move(moves, rank_index, file_index)
    generate_special_move(moves, rank_index, file_index)
    generate_capture_moves(moves, rank_index, file_index)
    return moves.compact
  end

  def generate_normal_move(moves, rank_index, file_index)
    rank_offset = rank_index + MOVE_SET[0] * direction()
    file_offset = file_index + MOVE_SET[1] * direction()
    new_position = [rank_offset, file_offset]
    moves << create_pawn_move(new_position)
  end

  def generate_special_move(moves, rank_index, file_index)
    rank_offset = rank_index + MOVE_SET[0] * direction()
    file_offset = file_index + MOVE_SET[1] * direction()
    front_position = [rank_offset, file_offset]
    rank_offset = rank_index + SPECIAL_MOVE[0] * direction()
    file_offset = file_index + SPECIAL_MOVE[1] * direction()
    new_position = [rank_offset, file_offset]
    moves << create_special_move(new_position, front_position)
  end

  def generate_capture_moves(moves, rank_index, file_index)
    CAPTURE_SET.each do |cap_set|
      rank_offset = rank_index + cap_set[0] * direction()
      file_offset = file_index + cap_set[1] * direction()
      new_position = [rank_offset, file_offset]
      moves << create_pawn_capture(new_position)
    end
  end

  def direction
    d = color == "white" ? -1 : 1
    return d
  end

end
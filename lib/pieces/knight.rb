require_relative "./abstract_piece" 

class Knight < AbstractPiece

  MOVE_SET = [[-1, -2], [-1, 2], [1, -2], [1, 2],
              [-2, -1], [-2, 1], [2, -1], [2, 1]]

  def get_legal_moves
    rank_index = @position_coordinates[0]
    file_index = @position_coordinates[1]
    create_moves_from_move_set(rank_index, file_index)
  end

  def create_moves_from_move_set(rank_index, file_index)
    moves = []
    MOVE_SET.each do |move_set|
      rank_offset = move_set[0]
      file_offset = move_set[1]
      new_position = [rank_index + rank_offset, 
                      file_index + file_offset]
      next if outside_of_board(new_position)
      moves << create_move(new_position)
    end
    moves.compact
  end




end
module BoardUtil
  
  def generate_coordinate_map
    coordinates = {}
    rank = 1
    files = "abcdefgh"
    7.downto(0) do |n|
      8.times do |m|
        coordinates["#{files[m]}#{rank}"] = [n, m]
      end
      rank += 1
    end
    return coordinates
  end


  def can_caslte_kingside?(pieces)
    (pieces.include?(:king) && !pieces[:king].moved) &&
    (pieces.include?(:king_rook) && !pieces[:king_rook].moved) 
  end


  def can_caslte_queenside?(pieces)
    (pieces.include?(:king) && !pieces[:king].moved) &&
    (pieces.include?(:queen_rook) && !pieces[:queen_rook].moved) 
  end

  def get_white_castling_pieces
    pieces = {}
    begin
      king = self.get_piece([7, 4])
      pieces[:king] = king
    rescue => e
    end
    begin
      king_rook = self.get_piece([7, 7])
      pieces[:king_rook] = king_rook
    rescue => e
    end
    begin
      queen_rook = self.get_piece([7, 0])
      pieces[:queen_rook] = queen_rook
    rescue => e
    end
    return pieces
  end
  
  def get_black_castling_pieces 
    pieces = {}
    begin
      king = self.get_piece([0, 4])
      pieces[:king] = king
    rescue => e
    end
    begin
      king_rook = self.get_piece([0, 7])
      pieces[:king_rook] = king_rook
    rescue => e
    end
    begin
      queen_rook = self.get_piece([0, 0])
      pieces[:queen_rook] = queen_rook
    rescue => e
    end
    return pieces
  end
end
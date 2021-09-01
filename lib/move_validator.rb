require_relative "./moves/normal_move"
require_relative "./moves/capture_move"
require_relative "./moves/promotion_move"
require_relative "./moves/special_move"


module MoveValidator

  def create_move(new_position)
    case
    when self.class == Pawn
      return create_pawn_move(new_position)
    when has_enemy_piece?(new_position)
      attacked_piece = self.board.get_piece(new_position)
      return CaptureMove.new(new_position, attacked_piece)
    when normal_move?(new_position)
      return NormalMove.new(new_position)
    end
  end

  def outside_of_board?(position_coordinates)
    return position_coordinates.any? { |el| !el.between?(0, 7) }
  end

  def has_piece?(new_position)
    !outside_of_board?(new_position) &&
    self.board.position_occupied?(new_position)
  end

  def has_friendly_piece?(new_position)
    !outside_of_board?(new_position) &&
    self.board.position_occupied?(new_position) &&
    self.board.get_piece(new_position).color == self.color
  end

  def has_enemy_piece?(new_position)
    !outside_of_board?(new_position) &&
    self.board.position_occupied?(new_position) &&
    self.board.get_piece(new_position).color != self.color
  end

  def normal_move?(new_position)
    !outside_of_board?(new_position) && 
    !self.board.position_occupied?(new_position)
  end

  def possible_capture?(new_position)
    !outside_of_board?(new_position) && 
    has_enemy_piece?(new_position)
  end

  module PawnMoves
    def create_pawn_move(new_position)
      case
      when normal_move?(new_position) && promotable?(new_position)
        return PromotionMove.new(new_position) 
      when normal_move?(new_position)
        return NormalMove.new(new_position)
      end
    end
      
    def create_special_move(new_position, front_position)
      if first_move?() && 
        !outside_of_board?(new_position) &&
        !has_piece?(front_position) && 
        !has_piece?(new_position) 
        return SpecialMove.new(new_position) 
      end
    end

    def create_en_passant(new_position, side_position)
      if normal_move?(new_position) && 
        possible_capture?(side_position)
        piece = self.board.get_piece(side_position)
        if piece.class == Pawn && piece.passable
          return CaptureMove.new(new_position, piece)
        end
      end
    end

    def create_pawn_capture(new_position) 
      if has_enemy_piece?(new_position)
        attacked_piece = self.board.get_piece(new_position)
        if promotable?(new_position)
          return PromotionMove.new(new_position, attacked_piece)
        else
          return CaptureMove.new(new_position, attacked_piece)
        end
      end
    end

    def first_move?
      return !self.moved
    end

    def promotable?(new_position)
      self.color == "black" && new_position[0] == 7 ||
      self.color == "white" && new_position[0] == 0
    end
    
  end

  module KingMoves
    def create_castle_move(new_position)
      
    end
  end

  include KingMoves
  include PawnMoves
end
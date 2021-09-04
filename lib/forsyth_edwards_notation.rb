require_relative "./pieces/bishop"
require_relative "./pieces/knight"
require_relative "./pieces/rook"
require_relative "./pieces/queen"
require_relative "./pieces/king"
require_relative "./pieces/pawn"

module ForsythEdwardsNotation

  def convert_to_fen(player_to_move, half_moves, full_moves)
    pieces = generate_pieces_fen()
    player = generate_player_to_move_fen(player_to_move)
    castling = generate_castling_fen()
    en_passant = generate_en_passant_fen()
    return "#{pieces} #{player} #{castling} #{en_passant} #{half_moves} #{full_moves}"
  end 

  def generate_pieces_fen
    fen = ""
    space = 0
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = get_piece(tile.position)
          fen.concat(space.to_s) if space != 0
          space = 0
          fen.concat(letter_selector(piece, piece.color))
        rescue => exception
          space += 1
        end
      end
      fen.concat(space.to_s) if space != 0
      fen.concat("/")
      space = 0
    end
    return fen.chop
  end

  def generate_player_to_move_fen(player_to_move)
    if player_to_move == "white"
      return "w"
    else
      return "b"
    end
  end

  def generate_castling_fen
    letters = ""
    white_pieces = get_white_castling_pieces
    black_pieces = get_black_castling_pieces
    if can_caslte_kingside?(white_pieces)
      letters.concat("K")
    end
    if can_caslte_queenside?(white_pieces)
      letters.concat("Q")
    end
    if can_caslte_kingside?(black_pieces)
      letters.concat("k")
    end
    if can_caslte_queenside?(black_pieces)
      letters.concat("q")
    end
    return letters == "" ? "-" : letters
  end

  def generate_en_passant_fen
    coordinates = generate_coordinate_map
    @board.each do |rank|
      rank.each do |tile|
        begin
          piece = self.get_piece(tile.position)
          if piece.class == Pawn
            if piece.passable
              if piece.color == "white"
                position = [piece.position_coordinates[0]+1, piece.position_coordinates[1]]
              else
                position = [piece.position_coordinates[0]-1, piece.position_coordinates[1]]
              end
              return coordinates[position]
            end
          end
        rescue => exception
          
        end
      end
    end
    return "-"
  end

  def convert_fen(fen_string)
    #rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    #(Pieces) (Player to move) (Castling) (En Passant) (Halfmove Clock) (Fullmove Clock)
    string_components = fen_string.split(" ")
    pieces = string_components[0].split("/")
    player_to_move = string_components[1]
    castling = string_components[2]
    passable = string_components[3]
    half_moves = string_components[4]
    full_moves = string_components[5]
    parse_piece_components(pieces)
    parse_castling(castling)
    parse_en_passant(passable, player_to_move)
    hash = {player: parse_player_to_move(player_to_move),
            half_moves: half_moves,
            full_moves: full_moves}
    return hash
  end

  def parse_piece_components(pieces)
    rank = 0
    file = 0
    pieces.each do |string|
      string.length.times do |n|
        letter = string[n]
        if /\d/ === letter
          file += letter.to_i
        else 
          piece = piece_selector(letter, [rank, file])
          self.set_piece(piece, [rank, file])
          if piece.class == Pawn
            mark_pawns_moved(piece, rank)
          end
          file += 1
        end
      end
      file = 0
      rank += 1
    end
      
  end

  def parse_player_to_move(player_to_move)
    if player_to_move == "w"
      return "white"
    else
      return "black"
    end
  end

  def parse_castling(castling)
    if !castling.include?("K")
      king = get_king("white")
      rook = get_rook("white", "king")
      mark_pieces_moved([king, rook])
    end
    if !castling.include?("Q")
      king = get_king("white")
      rook = get_rook("white", "queen")
      mark_pieces_moved([king, rook])
    end
    if !castling.include?("k")
      king = get_king("black")
      rook = get_rook("black", "king")
      mark_pieces_moved([king, rook])
    end
    if !castling.include?("q")
      king = get_king("black")
      rook = get_rook("black", "queen")
      mark_pieces_moved([king, rook])
    end  
  end

  def mark_pawns_moved(piece, rank)
    if piece.color == "white"
      if rank != 6
        mark_pieces_moved([piece])
      end
    else
      if rank != 1
        mark_pieces_moved([piece])
      end
    end
  end

  def mark_pieces_moved(pieces)
    pieces.each do |piece|
      if !piece.nil?
        piece.instance_variable_set(:@moved, true)
      end
    end
  end

  def get_king(color)
    begin
      if color == "white"
        return self.get_piece([7, 4])
      else
        return self.get_piece([0, 4])
      end
    rescue => exception
      
    end
  end

  def get_rook(color, side)
    begin
      if color == "white"
        if side == "king"
          return self.get_piece([7, 7])
        else
          return self.get_piece([7, 0])
        end
      else
        if side == "king"
          return self.get_piece([0, 7])
        else
          return self.get_piece([0, 0])
        end
      end
    rescue => exception
      
    end
  end

  def parse_en_passant(passable, player_to_move)
    coordinates = self.generate_coordinate_map()
    offset = player_to_move == "w" ? 1 : -1
    begin
      position = [passable[0]+offset, passable[1]]
      piece = self.get_piece(coordinates[position])
      if piece.class == Pawn
        piece.instance_variable_set(:@passable, true)
      end
    rescue => exception
    end
  end

  def piece_selector(letter, position)
    case 
    when letter == "k"
      return King.new("black", position, self)
    when letter == "q"
      return Queen.new("black", position, self)
    when letter == "b"
      return Bishop.new("black", position, self)
    when letter == "n"
      return Knight.new("black", position, self)
    when letter == "r"
      return Rook.new("black", position, self)
    when letter == "p"
      return Pawn.new("black", position, self)
    when letter == "K"
      return King.new("white", position, self)
    when letter == "Q"
      return Queen.new("white", position, self)
    when letter == "B"
      return Bishop.new("white", position, self)
    when letter == "N"
      return Knight.new("white", position, self)
    when letter == "R"
      return Rook.new("white", position, self)
    when letter == "P"
      return Pawn.new("white", position, self)
    end
  end

  def letter_selector(piece, color)
    case
    when piece.class == King
      letter = "k"
    when piece.class == Queen
      letter = "q"
    when piece.class == Rook
      letter = "r"
    when piece.class == Knight
      letter = "n"
    when piece.class == Bishop
      letter = "b"
    when piece.class == Pawn
      letter = "p"
    end
    if color == "white" 
      letter.capitalize!
    end
    return letter
  end

end
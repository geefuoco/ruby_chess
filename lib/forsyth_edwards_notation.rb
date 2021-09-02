require_relative "./pieces/bishop"
require_relative "./pieces/knight"
require_relative "./pieces/rook"
require_relative "./pieces/queen"
require_relative "./pieces/king"
require_relative "./pieces/pawn"

module ForsythEdwardsNotation

  def convert_fen(fen_string)
    #rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    #(Pieces) (Player to move) (Castling) (En Passant) (Halfmove Clock) (Fullmove Clock)
    string_components = fen_string.split(" ")
    pieces = string_components[0].split("/")
    parse_piece_components(pieces)
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
          file += 1
        end
      end
      file = 0
      rank += 1
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

end
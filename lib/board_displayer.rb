require "colorize"

module BoardDisplayer

  def print_board

    # exec("clear")
    count = 0
    row = ""
    piece_row = ""
    @board.each do |rank|
      
      rank.each do |tile|
        code = get_piece_code(tile)
        if count % 2 == 0
          row += "      ".colorize(:color => :black, :background => :light_white)
          piece_row += "  #{code}   ".colorize(:color => :black, :background => :light_white)
        else
          row += "      ".colorize(:color => :black, :background => :light_black)
          piece_row += "  #{code}   ".colorize(:color => :black, :background => :light_black)
        end
        count += 1
      end
      puts row
      puts piece_row
      puts row
      row = ""
      piece_row = ""
      count += 1
    end
  end

end

def get_piece_code(tile)
  piece_code = " "
  begin
    piece = tile.get_piece
    piece_code = piece.code
  rescue => e
  end
  return piece_code
end



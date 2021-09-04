require "colorize"

module BoardDisplayer

  def print_board
    count = 0
    rank_number = 8
    row = ""
    piece_row = ""
    @board.each do |rank|
      
      rank.each do |tile|
        code = get_piece_code(tile)
        append_row(row, piece_row, count, code)
        count += 1
      end
      puts row
      print piece_row
      print "#{rank_number}\n".yellow
      puts row
      rank_number -= 1
      row = ""
      piece_row = ""
      count += 1
    end

    puts "  a     b     c     d     e     f     g     h  ".yellow
  end

end

def append_row(row, piece_row, count, code)
  if count % 2 == 0
    append_row_white(row)
    append_piece_row_white(piece_row, code)
  else 
    append_row_black(row)
    append_piece_row_black(piece_row, code)
  end
end

def append_row_white(row)
  row.concat("      ".colorize(:color => :black, :background => :light_white))
end

def append_piece_row_white(piece_row, code)
  piece_row.concat("  #{code}   ".colorize(:color => :black, :background => :light_white))
end

def append_row_black(row)
  row.concat("      ".colorize(:color => :black, :background => :light_black))
end

def append_piece_row_black(piece_row, code)
  piece_row.concat("  #{code}   ".colorize(:color => :black, :background => :light_black))
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



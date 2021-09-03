require_relative "./board"

board = Board.new
board.convert_fen(Board::START)
board.print_board
require_relative "./board"
require_relative "./game"

board = Board.new
game = Game.new(board)

game.start


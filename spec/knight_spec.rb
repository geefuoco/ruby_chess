require_relative "../lib/pieces/knight"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"

describe Knight do

  subject(:knight) { Knight.new("white", [0, 1], Board.new) }

  describe "#get_legal_moves" do

    context "when called" do

      it "should give an array of legal coordinate positions" do
        expect(knight.get_legal_moves).to all(be_an(AbstractMove))
      end
    end

    context "when on an empty board at position [4, 4]" do 

      subject(:knight) { Knight.new("white", [4, 4], Board.new) }

      it "should return" do
        move_objects = knight.get_legal_moves
        moves = move_objects.map { |obj| obj.goal_position }
        expect(moves).to contain_exactly(
          [6, 5], [6, 3], [5, 6], [5, 2],
          [2, 3], [2, 5], [3, 6], [3, 2])
      end
    end

    context "when called" do
      subject(:knight_on_rim) { Knight.new("black", [5, 0], Board.new) }

      it "should not have any moves with values > 0 or < 7" do
        move_objects = knight.get_legal_moves
        moves = move_objects.map { |obj| obj.goal_position }
        expect(moves.any?{ |arr| arr.any? { |el| el<0 || el>7 } }).to be false
      end
    end

    context "if a tile at that position is occupied by a friendly piece, it is not a legal move" do
      board = Board.new
      subject(:knight) { Knight.new("black", [4, 4], board) }
      let(:piece) { instance_double("AbstractPiece", color: "black", position_coordinates: [5, 6]) }
      before do
        tile = board.get_tile([5, 6])
        tile.set_piece(piece)
      end
      it "should not have [5, 6] in its legal moves" do
        move_objects = knight.get_legal_moves
        moves = move_objects.map { |obj| obj.goal_position }
        expect(moves.include?([5, 6])).to be false
      end
    end
  end

end
require_relative "../lib/pieces/king"
require_relative "../lib/moves/abstract_move"
require_relative "../lib/board"

describe King do

  subject(:king) { King.new("white", [7, 4], Board.new)}

  describe "#get_legal_moves" do

    context "when called" do 

      it "should return an array of AbstractMoves" do
        moves = king.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when on position [7, 4]" do

      it "should return all legal moves" do
        moves = king.get_legal_moves  
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [7, 3], [7, 5], [6, 4], [6, 3], [6, 5]
        )
      end
    end

  end
end
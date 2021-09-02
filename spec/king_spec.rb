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

    context "when in a ready position to castle" do

      let(:board) { Board.new }
      
      it "should contain a castle move" do
        board.convert_fen("r1bqkb1r/pppp1ppp/2n2n2/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4")
        king = board.get_piece([7, 4])
        moves = king.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [6, 4], [7, 5], [7, 6]
        )
      end
    end

    context "when in a position not able to castle" do
      let(:board) { Board.new }
      
      it "should contain a castle move" do
        board.convert_fen("r1bqkb1r/pppp1ppp/2n2n2/1B2p3/4P3/5N2/PPPP1PPP/RNBQK1R1 b Qkq - 5 4")
        king = board.get_piece([7, 4])
        moves = king.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [6, 4], [7, 5]
        )
      end
    end

    context "when in the given position from the fen string" do

      let(:board) { Board.new }

      it "should only have 1 available move" do
        board.convert_fen("rn1q1rk1/pp2ppbp/3p1np1/8/3NPPb1/2N1B3/PPPQ2PP/R3KB1R w KQ - 5 9")
        king = board.get_piece([7, 4])
        moves = king.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [6, 5]
        )
      end
    end
  end

end
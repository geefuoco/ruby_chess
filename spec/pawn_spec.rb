require_relative "../lib/pieces/pawn"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"


describe Pawn do

  subject(:pawn) { Pawn.new("white", [1, 2], Board.new) }

  describe "#get_legal_moves" do

    context "when called" do 

      it "should return an array of AbstractMove objects" do
        moves = pawn.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when on the starting rank and moved is false" do
      it "should have 2 legal moves" do
        moves = pawn.get_legal_moves
        expect(moves.length).to eq(2)
      end
    end

    context "when on the starting rank and moved is true" do
      it "should have 1 legal move" do
        moves = pawn.get_legal_moves
        expect(moves.length).to eq(1)
      end
    end

  end

  describe "#direction" do

    context "when the piece is white" do

      it "should return -1" do
        expect(pawn.direction).to eq(-1)
      end
    end

    context "when the piece is black" do
      subject(:black_pawn) { Pawn.new("black", [1, 5], Board.new) }
      it "should return 1 " do
        expect(black_pawn.direction).to eq(1)
      end
    end
  end


end
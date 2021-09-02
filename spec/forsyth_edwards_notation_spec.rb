require_relative "../lib/forsyth_edwards_notation"
require_relative "../lib/board"
require "observer"


describe ForsythEdwardsNotation do 

  class DummyBoard
    include ForsythEdwardsNotation
    include Observable
  end

  let(:dummy) { DummyBoard.new }

  describe "#piece_selector" do

    context "when the letter is k" do  

      let(:king) { dummy.piece_selector("k", [1,2])}

      it "should return a king"   do
        expect(king.class).to eq(King)
        
      end

      it "should be the color black" do
        expect(king.color).to eq("black")
      end
    end

    context "when the letter is N" do

      
      let(:knight) { dummy.piece_selector("N", [0, 0]) }
      

      it "should return a Knight" do  
        expect(knight.class).to eq(Knight)
      end

      it "should be the color white" do
        expect(knight.color).to eq("white")
      end
    end
  end

  describe "#parse_piece_components" do

    context "when given a fen string" do 

      let(:test_board) { Board.new }

      it "should set the position of the pieces on the board" do
        fen = "r6r/p6p/8/8/8/8/P6P/4K3"
        args = fen.split("/")
        test_board.parse_piece_components(args)
        piece = test_board.get_piece([0, 0])
        expect(piece.class).to eq(Rook)

      end
    end
  end

end

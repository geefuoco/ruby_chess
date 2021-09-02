require_relative "../lib/forsyth_edwards_notation"
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

end

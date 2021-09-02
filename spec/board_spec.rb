require_relative "../lib/board"
require_relative "../lib/chess_errors/chess_exceptions"

describe Board do

  subject(:board) { Board.new }
  
  describe "#get_tile" do
    context "when given a position array" do
      it "should return the tile at that position" do
        expect(board.get_tile([0, 0])).to_not be_nil
      end
    end
  end
  
  describe "#set_tile" do 
    context "when given a tile and position array" do
      let(:tile) { instance_double("Tile", piece: "definitely_a_piece", occupied?: true) }
      before do
        board.set_tile(tile, [1, 1])
      end
      it "should set the tile to that position in the board" do
        expect(board.position_occupied?([1, 1])).to be true
      end
    end
  end

  describe "#position_occupied?" do 
    context "When given a position array with no piece on it" do 
      it "should return false" do
        expect(board.position_occupied?([1, 1])).to be false
      end
    end

    context "when given a position with a piece on it " do
      let(:piece) { instance_double("AbstractPiece") }
      let(:tile) { instance_double("Tile", piece: "piece", occupied?: true) }
      before do
        board.set_tile(tile, [1, 1])
      end
      it "should return true" do
        expect(board.position_occupied?([1, 1])).to be true
      end
    end
  end

  describe "#get_piece" do 
    context "when given a coordinate position" do
      it "should raise a NoPieceError if no piece is there" do
        expect{ board.get_piece([5,7]) }.to raise_error(ChessExceptions::NoPieceError)
      end
    end
  end

  describe "#set_piece" do
    context "when given a piece and coordinate positions" do 

      let(:piece) { instance_double("AbstractPiece", position_coordinates: [4, 4], color: "black")}
    
      it "should set the tile with the corresponding piece" do
        board.set_piece(piece, [4, 4])
        expect(board.get_piece([4, 4])).to eq(piece)
      end
    end
  end

  describe "#check?" do
    context "when it is check" do

      xit "should return true" do

      end
    end
  end
  
end
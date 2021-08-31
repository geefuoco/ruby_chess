require_relative "../lib/tile"
require_relative "../lib/chess_errors/chess_exceptions"

describe Tile do

  subject(:tile) { Tile.new(0, 0) }

  describe "#get_piece" do

    context "when the piece attribute is nil" do

      it "should raise a NoPieceError" do 
        expect{ tile.get_piece }.to raise_error(ChessExceptions::NoPieceError)
      end
    end

    context "when there is a piece on the tile" do 

      let(:piece) { instance_double("AbstractPiece")}
      subject(:t) { Tile.new(5, 4, piece)}

      it "should return the piece object" do 
        expect(t.get_piece).to_not be_nil
      end
    end
  end

  describe "#occupied?" do

    context "when the tile has a piece on it " do

      let(:piece) { instance_double("AbstractPiece")}
      subject(:tile) { Tile.new(0, 0, piece)}

      it "should be occupied" do

        expect(tile).to be_occupied
      end
    end

    context "when the tile is empty" do 
      subject(:empty_tile) { Tile.new(0, 0) }
      it "should not be occupied" do
        expect(tile).to_not be_occupied
      end
    end
  end

  describe "#set_piece" do 

    context "when given a piece object" do 
      let(:piece) { instance_double("AbstractPiece") }
      subject(:tile) { Tile.new(6, 6) }
      before do
        tile.set_piece(piece)
      end
      it "should update the tile with a piece" do
        expect(tile).to be_occupied
      end
    end

  end

  describe "#remove_piece" do

    context "when given a tile with a piece" do
      let(:piece) { instance_double("AbstractPiece") } 
      subject(:tile) { Tile.new(1, 1, piece) }
      before do
        tile.remove_piece
      end
      it "should set the piece attribute to nil" do
        expect(tile).to_not be_occupied
      end
    end
  end

end
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

    context "when the piece is set on position [0, 0]" do
      let(:piece) { instance_double("AbstractPiece", position_coordinates: [0, 0], color: "black")}
      it "should put a piece on [0, 0]" do
        board.set_piece(piece, [0, 0])
        expect(board.get_piece([0, 0])).to eq(piece)
      end
    end
  end

  describe "#remove_piece" do

    context "when given a position" do

      let(:piece)  { instance_double("AbstractPiece", position_coordinates: [0, 0], color: "black") }

      it "should remove the piece from the position" do 
        board.set_piece(piece, [0, 0])
        board.remove_piece([0, 0])
        expect{board.get_piece([0, 0])}.to raise_error(ChessExceptions::NoPieceError)
      end
    end
  end

  describe "#check?" do
    context "when it is check" do

      subject(:board) { Board.new }

      it "should return true" do
        board.convert_fen("rnbqk1nr/pppp1ppp/8/4p3/1b1PP3/8/PPP2PPP/RNBQKBNR w KQkq - 1 3")
        expect(board).to be_check
      end
    end

    context "another position that is check" do

      subject(:board)  { Board.new }

      it "should return true" do
        board.convert_fen("r1bq1rk1/ppp5/3p3p/1B3pp1/3bn3/2N2P2/PPP3PP/R2Q1RK1 w - - 0 14")
        expect(board).to be_check
      end
    end
    context "when it is not check" do 
      subject(:board) { Board.new }

      it "should return false" do
        board.convert_fen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        expect(board).to_not be_check

      end
    end
  end

  
end
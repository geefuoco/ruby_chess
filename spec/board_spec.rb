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

  describe "#valid_piece_move?" do

    context "when the move is valid" do

      subject(:board) { Board.new }

      it "should return true" do
        board.convert_fen(Board::START)
        pawn = board.get_piece([6, 1])
        expect(board.valid_piece_move?(pawn, [6, 3])).to be
      end
    end

    context "when the move will put a king in check" do

      subject(:board) { Board.new }

      it "should return false" do
        board.convert_fen("rnbqk1nr/ppp2ppp/4p3/3p4/1bPP4/2N5/PP2PPPP/R1BQKBNR w KQkq - 2 4")
        knight = board.get_piece([5, 2])
        expect(board.valid_piece_move?(knight, [4, 0])).to be false
      end
    end
  end


  describe "#get_checked_king" do

    context "when a king is in check" do

      let(:board) { Board.new }
      
      it "should return the king object" do 
        board.convert_fen("rnbqk1nr/pppp1ppp/8/4p3/1b1PP3/8/PPP2PPP/RNBQKBNR w KQkq - 1 3")
        king = board.get_piece([7, 4])
        checked = board.get_checked_king
        expect(king).to eq(checked)

      end
    end

    context "when there is not a king in check" do

      it "should return nil" do
        board.convert_fen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        checked = board.get_checked_king
        expect(checked).to be_nil
      end
    end
  end

  describe "#get_pieces_attacking_king" do

    context "when a piece is attacking a king" do

      let(:board) { Board.new }

      it "should be in this array" do
        board.convert_fen("rnb1kbnr/pppp1ppp/8/4p3/5P1q/P7/1PPPP1PP/RNBQKBNR w KQkq - 1 3")
        piece = board.get_piece([4, 7])
        attacking_pieces = board.get_pieces_attacking_king
        expect(attacking_pieces).to contain_exactly(piece)
      end
    end
  end

  describe "#piece_can_be_captured?" do 

    context "when a piece is on a sqaure that is not available to capture" do

      subject(:board) { Board.new }

      it "should return false" do
        board.convert_fen("rnbqkb1r/pppp1Qpp/8/4p3/2B1n3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4")
        queen = board.get_piece([1, 5])
        expect(board.piece_can_be_captured?(queen)).to be false
      end
    end

    context "when a piece is on a square tha can be captured" do

      subject(:board) { Board.new }

      it "should return true" do
        board.convert_fen("rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2")
        black_pawn = board.get_piece([3, 3])
        expect(board.piece_can_be_captured?(black_pawn)).to be 
      end
    end
  end

  describe "#checkmate?" do

    context "when the king is in check with no available moves" do

      let(:checkmated_board) { Board.new }

      it "should be checkmate" do
        checkmated_board.convert_fen("rnbqkb1r/pppp1Qpp/8/4p3/2B1n3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4")
        expect(checkmated_board).to be_checkmate
      end
    end

    context "when the attacking piece can be captured" do

      let(:not_checkmate) { Board.new }

      it "should not be checkmate" do
        not_checkmate.convert_fen("r1bnkb1r/ppppqQpp/8/4p3/P1B1n3/2N5/1PPP1PPP/R1B1K1NR b KQkq - 0 7")
        expect(not_checkmate).to_not be_checkmate
      end
    end

    context "when the attacking piece can be blocked" do

      let(:blocked_check) { Board.new }

      it "should not be checkmate" do
        blocked_check.convert_fen("rnb1kbnr/pppp1ppp/8/4p3/5P1q/P7/1PPPP1PP/RNBQKBNR w KQkq - 1 3")
        expect(blocked_check).to_not be_checkmate
      end
    end
  end

  
end
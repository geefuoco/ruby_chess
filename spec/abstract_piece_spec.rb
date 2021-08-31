
require_relative "../lib/pieces/abstract_piece"
require_relative "../lib/chess_errors/chess_exceptions"


describe AbstractPiece do 
  let(:board) { instance_double("Board", add_observer: "ok") }
  subject(:piece) { AbstractPiece.new("black", [0, 0], board) } 

  describe "#get_legal_moves" do

    context "when called on the Piece baseclass" do

      it "should raise an error " do

        expect{piece.get_legal_moves}.to raise_error(ChessExceptions::BaseClassError)
      end
    end
  end

end
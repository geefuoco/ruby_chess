require_relative "../lib/board"
require_relative "../lib/board_util"

describe BoardUtil do

  describe "#get_white_castling_pieces" do

    context "when white rooks and king are on original squares" do
      
      it "return a hash of rooks and king " do
        board = Board.new
        board.convert_fen(Board::START)
        pieces = board.get_white_castling_pieces
        expect(pieces.keys).to contain_exactly(
          :king, :king_rook, :queen_rook
        )
      end
    end

    context "when not on their original squares " do

      it "should only return pieces who are on original squares" do
        board = Board.new
        board.convert_fen("rnbqkbnr/pppp1ppp/5p2/8/8/5P2/PPPPKPPP/RNBQ1BNR KQ - 0 1")
        pieces = board.get_white_castling_pieces
        expect(pieces.keys).to contain_exactly(
          :king_rook, :queen_rook
        )
      end
    end
  end

end
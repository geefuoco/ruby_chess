require_relative "../lib/pieces/rook"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"

describe Rook do

  subject(:rook) { Rook.new("white", [3, 3], Board.new) }

  describe "#get_legal_moves" do
    
    context "when called" do 
      
      it "should return an array of abstract move objects" do
        moves = rook.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when called with a position of [3, 3]" do 

      it "should return all positions on 4th rank and 4th file" do
        moves = rook.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [0, 3], [1, 3], [2, 3], [4, 3],
          [5, 3], [6, 3], [7, 3], [3, 0],
          [3, 1], [3, 2], [3, 4], [3, 5],
          [3, 6], [3, 7]
        )
      end
    end

    context "when called with a friendly piece on [3, 4]" do
      let(:board) { Board.new }
      let(:friendly_piece) { instance_double("AbstractPiece", color: "white", position_coordinates: [3, 4])}
      let(:tile) { instance_double("Tile", get_piece: friendly_piece, occupied?: true) }
      let(:rook) { Rook.new("white", [3, 3], board)}
      it "should not have moves [3, 4] .. [3, 7]" do
        board.set_tile(tile, [3, 4])
        moves = rook.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [0, 3], [1, 3], [2, 3], [4, 3],
          [5, 3], [6, 3], [7, 3], [3, 0],
          [3, 1], [3, 2]
        )
      end
    end

    context "when called with a enemy piece on [3, 4]" do
      let(:board) { Board.new }
      let(:enemy_piece) { instance_double("AbstractPiece", color: "black", position_coordinates: [3, 4])}
      let(:tile) { instance_double("Tile", get_piece: enemy_piece, occupied?: true) }
      let(:rook) { Rook.new("white", [3, 3], board)}
      it "should not have moves [3, 5] .. [3, 7]" do
        board.set_tile(tile, [3, 4])
        moves = rook.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [0, 3], [1, 3], [2, 3], [4, 3],
          [5, 3], [6, 3], [7, 3], [3, 0],
          [3, 1], [3, 2], [3, 4]
        )
      end
    end
  end

end
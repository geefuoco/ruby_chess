require_relative "../lib/pieces/queen"
require_relative "../lib/moves/abstract_move"
require_relative "../lib/board"

describe Queen do
  
  subject(:queen) { Queen.new("white", [2, 7], Board.new) }

  describe "#get_legal_moves" do

    context "when called" do 

      it "should return an array of abstract moves" do
        moves = queen.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when there is a friendly piece on [5, 4] and [4, 7]" do

      let(:board) { Board.new }
      let(:friendly_piece) { instance_double("AbstractPiece", color: "white", position_coordinates: [5, 4])}
      let(:other_friendly_piece) { instance_double("AbstractPiece", color: "white", position_coordinates: [4, 7])}
      let(:tile) { instance_double("Tile", get_piece: friendly_piece, occupied?: true) }
      let(:other_tile) { instance_double("Tile", get_piece: other_friendly_piece, occupied?: true) }
      let(:queen) { Queen.new("white", [2, 7], board)}

      it "should not have moves passed the two friendly pieces" do
        board.set_tile(tile, [5, 4])
        board.set_tile(other_tile, [4, 7])
        moves = queen.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [0, 7], [1, 7], [3, 7], [2, 0],
          [2, 1], [2, 2], [2, 3], [2, 4],
          [2, 5], [2, 6], [1, 6], [0, 5],
          [3, 6], [4, 5]
        )
      end
    end

    context "when there is an enemy piece on [5, 4] and [4, 7]" do
      let(:board) { Board.new }
      let(:enemy_piece) { instance_double("AbstractPiece", color: "black", position_coordinates: [5, 4])}
      let(:other_enemy_piece) { instance_double("AbstractPiece", color: "black", position_coordinates: [4, 7])}
      let(:tile) { instance_double("Tile", get_piece: enemy_piece, occupied?: true) }
      let(:other_tile) { instance_double("Tile", get_piece: other_enemy_piece, occupied?: true) }
      let(:queen) { Queen.new("white", [2, 7], board)}

      it "should not have moves passed the two friendly pieces" do
        board.set_tile(tile, [5, 4])
        board.set_tile(other_tile, [4, 7])
        moves = queen.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [0, 7], [1, 7], [3, 7], [2, 0],
          [2, 1], [2, 2], [2, 3], [2, 4],
          [2, 5], [2, 6], [1, 6], [0, 5],
          [3, 6], [4, 5], [5, 4], [4, 7]
        )
      end
    end
  end


end

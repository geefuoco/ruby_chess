require_relative "../lib/pieces/bishop"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"

describe Bishop do
  
  subject(:bishop) { Bishop.new("white", [0, 0], Board.new) }

  describe "#get_legal_moves" do

    context "when called" do

      it "should return an array of move objects" do
        moves = bishop.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when called with the position coordinate [0, 0]" do

      it "should contain all coordinates along the a8-h1 diagnol" do

        moves = bishop.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]
        )
      end
    end

    context "when called with a position of [4, 4]" do

      subject(:bishop) { Bishop.new("white", [4, 4], Board.new) }

      it "should contain all coordinates along the a1-h8 and g1-a7 diagnols" do
        moves = bishop.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [7, 1], [6, 2], [5, 3], [3, 5],
          [2, 6], [1, 7], [0, 0], [1, 1],
          [2, 2], [3, 3], [5, 5], [6, 6],
          [7, 7] 
        )
      end
    end

    context "when there is a friendly piece on [3, 3]" do
      let(:board) { Board.new }
      let(:friendly_piece) { instance_double("AbstractPiece", color: "white", position_coordinates: [3, 3])}
      let(:tile) { instance_double("Tile", get_piece: friendly_piece, occupied?: true) }
      subject(:bad_bishop) { Bishop.new("white", [0, 0], board)}
      it "should only contain moves before that piece" do
        board.set_tile(tile, [3, 3])
        moves = bad_bishop.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [1, 1], [2, 2]
        )
      end
    end

    context "when there is an enemy piece on [3, 3]" do
      let(:board) { Board.new }
      let(:enemy_piece) { instance_double("AbstractPiece", color: "black", position_coordinates: [3, 3])}
      let(:tile) { instance_double("Tile", get_piece: enemy_piece, occupied?: true) }
      subject(:bishop) { Bishop.new("white", [0, 0], board)}
      it "should only contain moves including position of enemy piece" do
        board.set_tile(tile, [3, 3])
        moves = bishop.get_legal_moves
        expect(moves.map { |mv| mv.goal_position }).to contain_exactly(
          [1, 1], [2, 2], [3, 3]
        )
      end
    end
  end

end
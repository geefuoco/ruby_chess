require_relative "../lib/pieces/pawn"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"


describe Pawn do

  subject(:pawn) { Pawn.new("black", [1, 2], Board.new) }

  describe "#get_legal_moves" do

    context "when called" do 

      it "should return an array of AbstractMove objects" do
        moves = pawn.get_legal_moves
        expect(moves).to all(be_an(AbstractMove))
      end
    end

    context "when on the starting rank and moved is false" do
      it "should have 2 legal moves" do
        moves = pawn.get_legal_moves
        expect(moves.length).to eq(2)
      end
    end

    context "when on the starting rank and moved is true" do
      it "should have 1 legal move" do
        pawn.move([1, 2])
        moves = pawn.get_legal_moves
        expect(moves.length).to eq(1)
      end
    end

    context "when at the position [2, 1] as a black pawn" do
      subject(:black_pawn) { Pawn.new("black", [2, 1], Board.new) }
      it "should contain [3, 1] only" do
        black_pawn.move([2, 1])
        moves = black_pawn.get_legal_moves
        expect(moves.map { |mv| mv.goal_position}).to contain_exactly(
          [3, 1]
        )
      end
    end

    context "when at the position [2, 1] as black pawn and a piece on [3, 2]" do

      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("black", [2, 1], board) }

      let(:piece) { instance_double("AbstractPiece", position_coordinates: [3, 2], color: "white") }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: piece)}
    

      it "should contain 2 moves" do
        board.set_tile(tile, [3, 2])
        pawn.move([2, 1])
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }).to contain_exactly(
          [3, 1], [3, 2]
        )
      end
    end

    context "when at the position [2, 1] as black pawn and a piece on [3, 1]" do

      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("black", [2, 1], board) }

      let(:piece) { instance_double("AbstractPiece", position_coordinates: [3, 1], color: "white") }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: piece)}
    

      it "should contain no moves" do
        board.set_tile(tile, [3, 1])
        pawn.move([2, 1])
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }).to be_empty
      end
    end

    context "when at the position [1, 1] as black pawn and a piece on [2, 1]" do

      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("black", [1, 1], board) }

      let(:piece) { instance_double("AbstractPiece", position_coordinates: [2, 1], color: "white") }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: piece)}
    

      it "should contain no moves" do
        board.set_tile(tile, [2, 1])
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }).to be_empty
      end
    end

    context "when at the position [1, 1] as black pawn and a piece on [3, 1]" do

      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("black", [1, 1], board) }

      let(:piece) { instance_double("AbstractPiece", position_coordinates: [3, 1], color: "white") }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: piece)}
    

      it "should contain no moves" do
        board.set_tile(tile, [3, 1])
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }).to contain_exactly(
          [2, 1]
        )
      end
    end
      
  end

  describe "#direction" do

    context "when the piece is white" do
      subject(:pawn) { Pawn.new("white", [0, 0], Board.new)}
      it "should return -1" do
        expect(pawn.direction).to eq(-1)
      end
    end

    context "when the piece is black" do
      subject(:black_pawn) { Pawn.new("black", [1, 5], Board.new) }
      it "should return 1 " do
        expect(black_pawn.direction).to eq(1)
      end
    end
  end


end
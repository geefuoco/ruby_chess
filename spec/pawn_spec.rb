require_relative "../lib/pieces/pawn"
require_relative "../lib/board"
require_relative "../lib/moves/abstract_move"
require_relative "../lib/moves/promotion_move"

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
      let(:move) { instance_double("NormalMove", goal_position: [1, 2])}

      it "should have 1 legal move" do
        pawn.move(move)
        moves = pawn.get_legal_moves
        expect(moves.length).to eq(1)
      end
    end

    context "when at the position [2, 1] as a black pawn" do
      subject(:black_pawn) { Pawn.new("black", [2, 1], Board.new) }
      let(:move) { instance_double("NormalMove", goal_position: [2, 1])}

      it "should contain [3, 1] only" do
        black_pawn.move(move)
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
      let(:move) { instance_double("NormalMove", goal_position: [2, 1])}
      

      it "should contain 2 moves" do
        board.set_tile(tile, [3, 2])
        pawn.move(move)
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
      let(:move) { instance_double("NormalMove", goal_position: [2, 1])}

      it "should contain no moves" do
        board.set_tile(tile, [3, 1])
        pawn.move(move)
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

    context "when at the position [6, 0] as a black pawn" do

      subject(:black_pawn) { Pawn.new("black", [6, 0], Board.new) }
      it "should contain a promotion move" do
        moves = black_pawn.get_legal_moves
        expect(moves).to all(be_a(PromotionMove))
      end
    end

    context "when at position [4, 4] as a white pawn" do
      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("white", [4, 4], board) }
      let(:enemy_pawn) { Pawn.new("black", [4, 3], board) }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: enemy_pawn)}

      it "should be able to enpassant a black pawn on [4, 3]" do
        board.set_tile(tile, [4, 3])
        enemy_pawn.instance_variable_set(:@passable, true)
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }.include?([3, 3])).to be
      end
    end

    context "when at position [4, 4] as white pawn " do
      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("white", [4, 4], board) }
      let(:enemy_pawn) { Pawn.new("black", [4, 5], board) }
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: enemy_pawn)}

      it "should be able to enpassant a black pawn on [4, 5]" do
        board.set_tile(tile, [4, 5])
        enemy_pawn.instance_variable_set(:@passable, true)
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }.include?([3, 5])).to be
      end
    end

    context "when at position [4, 4] as white pawn " do
      let(:board) { Board.new}
      subject(:pawn) { Pawn.new("white", [4, 4], board) }
      let(:enemy_pawn) { Pawn.new("black", [4, 5], board) }
      let(:not_passable) { Pawn.new("black", [4, 3], board)}
      let(:tile) { instance_double("Tile", occupied?: true, get_piece: enemy_pawn)}

      it "should be able to enpassant a black pawn on [4, 5]" do
        pawn.instance_variable_set(:@moved, true)
        board.set_tile(tile, [4, 5])
        enemy_pawn.instance_variable_set(:@passable, true)
        moves = pawn.get_legal_moves
        expect(moves.map{ |mv| mv.goal_position }).to contain_exactly(
          [3, 4], [3, 5]
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
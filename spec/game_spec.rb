require_relative "../lib/game"
require_relative "../lib/board"

describe Game do
  let(:board) { Board.new }
  subject(:game) { Game.new(board)}
  

  describe "#game_over" do 

    context "when there is checkmate on the board" do

      it "should call the checkmate? method " do
        expect(board).to receive(:checkmate?).once
        game.game_over?()
      end
    end
  end

  describe "#get_player_selection" do 

    context "when called" do

      before do
        board.convert_fen(Board::START)
        allow(game).to receive(:gets).and_return("e2\n")
      end

      it "should call get_piece"  do
        expect(board).to receive(:get_piece).once
        game.get_player_selection
      end

      it "should call select_piece" do
        expect(board).to receive(:select_piece).once
        game.get_player_selection
      end
    end
  end

  describe "#execute_player_move" do 

    context "when called" do

      before do
        board.convert_fen(Board::START)
        allow(game).to receive(:gets).and_return("e2\n")
      end

      it "should call get_player_selection once" do
        expect(game).to receive(:get_player_selection).once
        game.execute_player_move
      end

    end
  end

  describe "#read_save_file" do

    context "when the file is found"  do

      before do
        allow(Dir).to receive(:children).with("saved_games").and_return([])
        allow(game).to receive(:gets).and_return("0")
      end

      it "should send a message to the Dir class" do
        expect(Dir).to receive(:children).once
        game.read_save_file
      end

    end
  end

  describe "#load_file" do

    context "when given a saved game file in fen string format" do

      before do
        allow(File).to receive(:open)
        allow(game).to receive(:load_game_from_fen)
      end

      it "should open the file " do
        expect(File).to receive(:open).once
        game.load_file("test")
      end

    end
  end

  describe "#save" do

    context "when the game is saved" do

      before do
        allow(File).to receive(:open)
        allow(Dir).to receive(:exist?).and_return(false)
        allow(Dir).to receive(:mkdir)
        allow(Dir).to receive(:children).with("saved_games").and_return([])
      end
      
      it "should open a file" do
        expect(File).to receive(:open).once
        game.save
      end

      it "should see if a directory exists" do
        expect(Dir).to receive(:exist?).once
        game.save
      end

      it "should make a directory if one does not exist" do
        expect(Dir).to receive(:mkdir).once
        game.save
      end
    end
  end

  describe "#process_half_moves" do

    context "when a piece on the board that is not a pawn is moved" do
      let(:pawn) { instance_double("Pawn", class: Pawn)}
      let(:move) { instance_double("NormalMove", class: NormalMove)}

      it "should not increment the half_moves attribute" do
        game.process_half_moves(pawn, move)
        half_moves = game.instance_variable_get(:@half_moves)
        expect(half_moves).to eq(0)
      end
    end

    context "when a move is a capture move " do

      let(:piece) { instance_double("Bishop", class: Bishop)}
      let(:move) { instance_double("CaptureMove", class: CaptureMove)}

      it "should not increment that half_moves attribute" do
        game.process_half_moves(piece, move)
        half_moves = game.instance_variable_get(:@half_moves)
        expect(half_moves).to eq(0)
      end
    end

    context "when it is not a pawn move or capture move" do

      let(:piece) { instance_double("King", class: King)}
      let(:move) { instance_double("NormalMove", class: NormalMove)}

      it "should incremenet the half_moves attribute" do
        game.process_half_moves(piece, move)
        half_moves = game.instance_variable_get(:@half_moves)
        expect(half_moves).to eq(1)
      end
    end
  end
end
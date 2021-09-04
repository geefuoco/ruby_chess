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

      it "should call execute_move" do
        expect(board).to receive(:execute_move).once
        game.execute_player_move
      end

    end
  end

end
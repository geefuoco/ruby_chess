
module ChessExceptions

  class NoPieceError < StandardError
    def initialize(msg="No piece was found on the square")
      super
    end
  end

  class BaseClassError < StandardError
    def initialize(msg="Warning: This method should be implemented by child classes")
      super
    end
  end

  class OutsideOfBoardError < StandardError
    def initialize(msg="Position was outside of the board")
      super
    end
  end

end
module Cobi
  class Heading
    attr_reader :text
    def initialize(text)
      @text = text
    end

    def to_s
      Pastel.new.on_black.white(text)
    end

    def focused?
      false
    end
  end
end

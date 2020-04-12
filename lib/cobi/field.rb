module Cobi
  class Field
    attr_accessor :value, :text, :focused, :length
    def initialize(text, length)
      @text = text
      @length = length
      @focused = false
      @value = ''
    end

    def to_s
      pastel_ctx = focused? ? Pastel.new.on_white : Pastel.new.on_black
      pastel_ctx.blue(text + ': ') + pastel_ctx.green(value + '_' * (length - value.length))
    end

    def focused?
      !!focused
    end
  end
end
 

require 'pastel'
require 'readline'
require 'io/console'
require "cobi/version"
require "cobi/field"
require "cobi/heading"

module Cobi
  class Screen
    attr_reader :screen_height, :on_submit

    def initialize(on_submit = Proc.new { exit(1) })
      @elements = []
      @screen_height = `tput lines`.to_i
      @on_submit = on_submit
    end

    def run
      # Focus the first field
      @elements.find { |e| e.is_a?(Field) }.focused = true

      while true
        draw
        get_command
      end
    end

    def heading(text)
      @elements << Heading.new(text)
      self
    end

    def field(text, length = 10)
      @elements << Field.new(text, length)
      self
    end

    private

    def pastel
      @pastel ||= Pastel.new.on_black
    end

    def draw
      # first clear the screen, in case the terminal size calculation is offset by footers/tmux separators
      puts pastel.black("\e[H\e[2J")

      @elements.each do |e|
        puts e.to_s
      end

      puts pastel.black("\n" * (screen_height - @elements.length - 4))
      puts pastel.green("Ctrl+C to quit")
    end

    def get_command
      cmd = STDIN.getch
      exit(1) if cmd == "\u0003" # exit on Ctrl+C

      if cmd == "\t" # tab
        switch_focus
      elsif cmd # TODO only if alphanumeric
        handle_character(cmd)
      elsif cmd == 'enter' # TODO
        handle_submit
      end
    end

    def handle_select
      on_submit.call
    end

    def handle_character(char)
      @elements.find { |e| e.focused? }.value += char
    end

    def switch_focus
      focused_index = @elements.find_index { |e| e.focused? }

      next_index = focused_index + 1
      until @elements[next_index] && @elements[next_index].is_a?(Field)
        next_index += 1
        next_index = 0 unless @elements[next_index]
      end

      @elements[focused_index].focused = false
      @elements[next_index].focused = true
    end
  end
end

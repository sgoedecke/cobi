require 'pastel'
require 'readline'
require 'io/console'
require "cobi/version"
require "cobi/field"
require "cobi/heading"

module Cobi
  class Screen
    attr_reader :screen_height

    def initialize
      @elements = []
      @screen_height = `tput lines`.to_i
      @running = false
    end

    def run
      # Focus the first field
      @elements.find { |e| e.is_a?(Field) }.focused = true
      @running = true

      while @running
        draw
        get_command
      end

      values
    end

    def on_submit(&block)
      @on_submit = block
      self
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
      puts pastel.green("Tab to switch fields | Enter to submit")
    end

    def get_command
      cmd = STDIN.getch
      exit(1) if cmd == "\u0003" # exit on Ctrl+C

      if cmd == "\t" # tab
        handle_switch_focus
      elsif cmd == "\n" || cmd == "\r" # TODO
        handle_submit
      elsif cmd =~/[[:alpha:]]/ || cmd =~ /[[:digit:]]/
        handle_character(cmd)
      end
    end

    def handle_submit
      @running = false
    end

    def values
      @elements.select { |e| e.is_a?(Field) }
        .map { |e| [e.text, e.value] }
        .to_h
    end

    def handle_character(char)
      @elements.find { |e| e.focused? }.value += char
    end

    def handle_switch_focus
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

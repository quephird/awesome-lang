require_relative 'regex'

module Readers
  class BeginBlock
    def initialize
      @reader = Regex.new /\A\:\n( +)/m do |chunk, stream, results|
        current_indent = results[:current_indent]
        new_indent = chunk.size

        # TODO: Need tests around this.
        if new_indent <= current_indent
          raise "Bad indent level, got #{new_indent} indents, " +
          "expected > #{current_indent}"
        end

        results[:tokens] <<= [:INDENT, new_indent]
        results[:current_indent] = new_indent
        results[:indent_stack] <<= new_indent
        results[:remaining_code] = stream[new_indent+2..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

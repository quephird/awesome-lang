require_relative 'regex'
require_relative 'newline'
require_relative 'close_block'

module Readers
  class Indent
    def initialize
      @reader = Regex.new /\A\n( *)/m do |chunk, stream, results|
        if chunk.size == results[:current_indent]
          results[:tokens] <<= [:NEWLINE, "\n"]
        elsif chunk.size < results[:current_indent]
          while chunk.size < results[:current_indent]
            results[:indent_stack].pop
            results[:current_indent] = results[:indent_stack].last || 0
            results[:tokens] <<= [:DEDENT, chunk.size]
          end
          results[:tokens] <<= [:NEWLINE, "\n"]
        else
          raise "Missing ':'"
        end

        results[:remaining_code] = stream[chunk.size+1..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

require_relative 'regex'

module Readers
  class Constant
    def initialize
      @reader = Regex.new /\A([A-Z]\w*)/ do |chunk, stream, results|
        results[:tokens] <<= [:CONSTANT, chunk]
        results[:remaining_code] = stream[chunk.size..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

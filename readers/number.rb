require_relative 'regex'

module Readers
  class Number
    def initialize
      @reader = Regex.new /\A([0-9]+)/ do |chunk, stream, results|
        results[:tokens] <<= [:NUMBER, chunk.to_i]
        results[:remaining_code] = stream[chunk.size..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

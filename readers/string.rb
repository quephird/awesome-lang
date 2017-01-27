require_relative 'regex'

module Readers
  class String
    def initialize
      @reader = Regex.new /\A"([^"]*)"/ do |chunk, stream, results|
        results[:tokens] <<= [:STRING, chunk]
        results[:remaining_code] = stream[chunk.size+2..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

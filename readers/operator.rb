require_relative 'regex'

module Readers
  class Operator
    def initialize
      @reader = Regex.new /\A(\|\||&&|==|!=|<=|>=)/ do |chunk, stream, results|
        results[:tokens] <<= [chunk, chunk]
        results[:remaining_code] = stream[chunk.size..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

require_relative 'regex'

module Readers
  class SingleCharacter
    def initialize
      @reader = Regex.new /\A(.)/ do |chunk, stream, results|
        results[:tokens] <<= [chunk, chunk]
        results[:remaining_code] = stream[1..-1]
        results
      end
    end

    def read(stream, results)
      @reader.read(stream, results)
    end
  end
end

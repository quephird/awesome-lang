require_relative 'sequence'

module Readers
  class Awesome
    def initialize(sequence_reader)
      @sequence_reader = sequence_reader
    end

    def read(stream)
      results = {
        tokens: [],
        current_indent: 0,
        indent_stack: [],
        remaining_code: stream
      }

      while !(remaining_code = results[:remaining_code]).empty?
        test_results = @sequence_reader.read(remaining_code, results)

        if !test_results[:match_found]
          # TODO: Add capturing of line and column numbers.
          raise "Parse error at line #{}, column #{}"
        end
      end

      results
    end
  end
end

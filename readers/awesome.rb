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

      loop do
        remaining_code = results[:remaining_code]

        if remaining_code.empty?
          # We've gone through all the code; we're done.
          break
        else
          test_results = @sequence_reader.read(remaining_code, results)

          if !test_results[:match_found]
            # We didn't get a match; we have a problem.
            raise "Parse error at line #{}, column #{}"
          end
        end
      end

      results
    end
  end
end

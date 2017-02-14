require_relative 'sequence'

module Readers
  # This class is initialized with a sequence reader, which
  # is already set up with list of regex-based readers.
  # Unlike the sequence reader, it will iterate through matched chunks
  # in the input stream/string being processed. It will either
  # continue to accumulate token name/value pairs in the results
  # structure, or if a match is not found by the sequence reader
  # it will throw an error halting processing.
  class Awesome
    # TODO: The sequence of readers needs to be constructed here
    def initialize(sequence_reader)
      @sequence_reader = sequence_reader
    end

    def read(stream)
      results = {
        tokens: [],
        current_indent: 0,
        indent_stack: [],
        remaining_code: stream.chomp!
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

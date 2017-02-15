require_relative 'begin_block'
require_relative 'constant'
require_relative 'identifier'
require_relative 'indent'
require_relative 'number'
require_relative 'operator'
require_relative 'single_character'
require_relative 'space'
require_relative 'string'
require_relative 'sequence'

module Readers
  # This class is initialized composed with a sequence reader,
  # which is set up with list of regex-based readers.
  # Unlike the sequence reader, it will iterate through matched chunks
  # in the input stream/string being processed. It will either
  # continue to accumulate token name/value pairs in the results
  # structure, or if a match is not found by the sequence reader
  # it will throw an error halting processing.
  class Awesome
    def initialize
      begin_block_reader = Readers::BeginBlock.new
      constant_reader = Readers::Constant.new
      identifier_reader = Readers::Identifier.new
      indent_reader = Readers::Indent.new
      number_reader = Readers::Number.new
      operator_reader = Readers::Operator.new
      single_character_reader = Readers::SingleCharacter.new
      space_reader = Readers::Space.new
      string_reader = Readers::String.new
      @reader = Readers::Sequence.new [
        identifier_reader,
        constant_reader,
        number_reader,
        string_reader,
        begin_block_reader,
        indent_reader,
        operator_reader,
        space_reader,
        single_character_reader,
      ]

    end

    def read(stream)
      results = {
        tokens: [],
        current_indent: 0,
        indent_stack: [],
        remaining_code: stream.chomp!
      }

      while !(remaining_code = results[:remaining_code]).empty?
        test_results = @reader.read(remaining_code, results)

        if !test_results[:match_found]
          # TODO: Add capturing of line and column numbers.
          raise "Parse error at line #{}, column #{}"
        end
      end

      results
    end
  end
end

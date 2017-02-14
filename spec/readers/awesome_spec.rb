require_relative '../../readers/begin_block'
require_relative '../../readers/constant'
require_relative '../../readers/identifier'
require_relative '../../readers/indent'
require_relative '../../readers/number'
require_relative '../../readers/operator'
require_relative '../../readers/single_character'
require_relative '../../readers/space'
require_relative '../../readers/string'
require_relative '../../readers/sequence'
require_relative '../../readers/awesome'

describe Readers::Awesome do
  let(:begin_block_reader) { Readers::BeginBlock.new }
  let(:constant_reader) { Readers::Constant.new }
  let(:identifier_reader) { Readers::Identifier.new }
  let(:indent_reader) { Readers::Indent.new }
  let(:number_reader) { Readers::Number.new }
  let(:operator_reader) { Readers::Operator.new }
  let(:single_character_reader) { Readers::SingleCharacter.new }
  let(:space_reader) { Readers::Space.new }
  let(:string_reader) { Readers::String.new }
  let(:sequence_reader) do
     Readers::Sequence.new [
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

  let(:awesome_reader) { Readers::Awesome.new sequence_reader}
  let(:example_code) {
    <<~EXAMPLE
      if 1:
        if 2:
          print("...")
          if false:
            pass
          print("done!")
        2

      print "The End"
    EXAMPLE
  }
  context 'example code from book' do
    tokens = [
      [:IF, "if"], [:NUMBER, 1],
        [:INDENT, 2],
        [:IF, "if"],
        [:NUMBER, 2],
        [:INDENT, 4],
          [:IDENTIFIER, "print"],
          ["(", "("],
          [:STRING, "..."],
          [")", ")"],
          [:NEWLINE, "\n"],
          [:IF, "if"],
          [:FALSE, "false"],
          [:INDENT, 6],
            [:IDENTIFIER, "pass"],
          [:DEDENT, 4],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, "print"],
          ["(", "("],
          [:STRING, "done!"],
          [")", ")"],
        [:DEDENT, 2],
        [:NEWLINE, "\n"],
        [:NUMBER, 2],
      [:DEDENT, 0],
      [:NEWLINE, "\n"],
      [:NEWLINE, "\n"],
      [:IDENTIFIER, "print"],
      [:STRING, "The End"],
    ]
    it 'should properly parse the code' do
      results = awesome_reader.read(example_code)
      expect(results[:tokens]).to eq tokens
    end
  end
end

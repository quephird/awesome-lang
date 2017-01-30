require_relative '../../readers/begin_block'
require_relative '../../readers/constant'
require_relative '../../readers/identifier'
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
  let(:number_reader) { Readers::Number.new }
  let(:operator_reader) { Readers::Operator.new }
  let(:single_character_reader) { Readers::SingleCharacter.new }
  let(:space_reader) { Readers::Space.new }
  let(:string_reader) { Readers::String.new }
  let(:sequence_reader) do
     Readers::Sequence.new [
       begin_block_reader,
       constant_reader,
       identifier_reader,
       number_reader,
       operator_reader,
       space_reader,
       string_reader,
       single_character_reader,
     ]
   end
  let(:awesome_reader) { Readers::Awesome.new sequence_reader}

  context 'input string contains a class definition' do
    it 'should properly parse the code' do
      input_code = "class Foo:\n  def foo(bar):\n    bar = \"foo\" * 42"
      results = awesome_reader.read(input_code)
      expect(results[:tokens]).to eq [
        [:CLASS, 'class'],
        [:CONSTANT, 'Foo'],
        [:INDENT, 2],
        [:DEF, 'def'],
        [:IDENTIFIER, 'foo'],
        ['(', '('],
        [:IDENTIFIER, 'bar'],
        [')', ')'],
        [:INDENT, 4],
        [:IDENTIFIER, 'bar'],
        ['=', '='],
        [:STRING, 'foo'],
        ['*', '*'],
        [:NUMBER, 42],
      ]
      expect(results[:remaining_code]).to eq ""
    end
  end
end

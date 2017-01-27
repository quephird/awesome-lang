require_relative '../../readers/constant'
require_relative '../../readers/identifier'
require_relative '../../readers/number'
require_relative '../../readers/space'
require_relative '../../readers/string'
require_relative '../../readers/sequence'
require_relative '../../readers/awesome'

describe Readers::Awesome do
  let(:constant_reader) { Readers::Constant.new }
  let(:identifier_reader) { Readers::Identifier.new }
  let(:number_reader) { Readers::Number.new }
  let(:space_reader) { Readers::Space.new }
  let(:string_reader) { Readers::String.new }
  let(:sequence_reader) do
     Readers::Sequence.new [
       constant_reader,
       identifier_reader,
       number_reader,
       space_reader,
       string_reader
     ]
   end
  let(:awesome_reader) { Readers::Awesome.new sequence_reader}

  context 'input string contains a class definition' do
    it 'should properly parse the code' do
      input_code = "class Foo    def foo   42  \"foo\""
      results = awesome_reader.read(input_code)
      expect(results[:tokens]).to eq [
        [:CLASS, 'class'],
        [:CONSTANT, 'Foo'],
        [:DEF, 'def'],
        [:IDENTIFIER, 'foo'],
        [:NUMBER, 42],
        [:STRING, 'foo']
      ]
      expect(results[:remaining_code]).to eq ""
    end
  end
end

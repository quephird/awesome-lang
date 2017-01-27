require_relative '../../readers/constant'
require_relative '../../readers/identifier'
require_relative '../../readers/number'
require_relative '../../readers/space'
require_relative '../../readers/sequence'

describe Readers::Sequence do
  let(:constant_reader) { Readers::Constant.new }
  let(:identifier_reader) { Readers::Identifier.new }
  let(:number_reader) { Readers::Number.new }
  let(:space_reader) { Readers::Space.new }
  let(:sequence_reader) do
     Readers::Sequence.new [
       constant_reader,
       identifier_reader,
       number_reader,
       space_reader
     ]
   end
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a keyword' do
    it 'should properly parse the keyword' do
      results = sequence_reader.read("def foo\n  42\nend", initial_results)
      expect(results[:tokens]).to eq [[:DEF, 'def']]
      expect(results[:remaining_code]).to eq " foo\n  42\nend"
    end
  end

  context 'input string begins with a space' do
    it 'should properly strip the space' do
      results = sequence_reader.read(" foo\n  42\nend", initial_results)
      expect(results[:tokens]).to eq []
      expect(results[:remaining_code]).to eq "foo\n  42\nend"
    end
  end

  context 'input string begins with an identifier' do
    it 'should properly parse the identifier' do
      results = sequence_reader.read("foo\n  42\nend", initial_results)
      expect(results[:tokens]).to eq [[:IDENTIFIER, 'foo']]
      expect(results[:remaining_code]).to eq "\n  42\nend"
    end
  end

  context 'input string begins with a number' do
    it 'should properly parse the number' do
      results = sequence_reader.read("42\nend", initial_results)
      expect(results[:tokens]).to eq [[:NUMBER, 42]]
      expect(results[:remaining_code]).to eq "\nend"
    end
  end
end

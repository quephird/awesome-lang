require_relative '../../readers/begin_block'
require_relative '../../readers/constant'
require_relative '../../readers/identifier'
require_relative '../../readers/number'
require_relative '../../readers/operator'
require_relative '../../readers/single_character'
require_relative '../../readers/space'
require_relative '../../readers/string'
require_relative '../../readers/sequence'

describe Readers::Sequence do
  let(:begin_block_reader) { Readers::BeginBlock.new }
  let(:constant_reader) { Readers::Constant.new }
  let(:identifier_reader) { Readers::Identifier.new }
  let(:number_reader) { Readers::Number.new }
  let(:operator_reader) { Readers::Operator.new }
  let(:space_reader) { Readers::Space.new }
  let(:single_character_reader) { Readers::SingleCharacter.new }
  let(:string_reader) { Readers::String.new }
  let(:sequence_reader) do
     Readers::Sequence.new [
       identifier_reader,
       constant_reader,
       number_reader,
       string_reader,
       begin_block_reader,
       operator_reader,
       space_reader,
       single_character_reader,
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
      results = sequence_reader.read("def foo:\n  bar == 42\nend", initial_results)
      expect(results[:tokens]).to eq [[:DEF, 'def']]
      expect(results[:remaining_code]).to eq " foo:\n  bar == 42\nend"
    end
  end

  context 'input string begins with a space' do
    it 'should properly strip the space' do
      results = sequence_reader.read(" foo:\n  bar == 42\nend", initial_results)
      expect(results[:tokens]).to eq []
      expect(results[:remaining_code]).to eq "foo:\n  bar == 42\nend"
    end
  end

  context 'input string begins with an identifier' do
    it 'should properly parse the identifier' do
      results = sequence_reader.read("foo:\n  bar == 42\nend", initial_results)
      expect(results[:tokens]).to eq [[:IDENTIFIER, 'foo']]
      expect(results[:remaining_code]).to eq ":\n  bar == 42\nend"
    end
  end

  context 'input string begins with a new block' do
    it 'should properly parse the new block' do
      results = sequence_reader.read(":\n  bar == 42\nend", initial_results)
      expect(results[:tokens]).to eq [[:INDENT, 2]]
      expect(results[:current_indent]).to eq 2
      expect(results[:indent_stack]).to eq [2]
      expect(results[:remaining_code]).to eq "bar == 42\nend"
    end
  end

  context 'input string begins with an operator' do
    it 'should properly parse the operator' do
      results = sequence_reader.read("== 42\nend", initial_results)
      expect(results[:tokens]).to eq [['==', '==']]
      expect(results[:remaining_code]).to eq " 42\nend"
    end
  end

  context 'input string begins with a number' do
    it 'should properly parse the number' do
      results = sequence_reader.read("42\nend", initial_results)
      expect(results[:tokens]).to eq [[:NUMBER, 42]]
      expect(results[:remaining_code]).to eq "\nend"
    end
  end

  context 'input string begins with a string literal' do
    it 'should properly parse the string literal' do
      results = sequence_reader.read("\"a string\"\nend", initial_results)
      expect(results[:tokens]).to eq [[:STRING, 'a string']]
      expect(results[:remaining_code]).to eq "\nend"
    end
  end

  context 'input string begins with a single character operator' do
    it 'should properly parse the string' do
      results = sequence_reader.read("+ 2\n  end", initial_results)
      expect(results[:tokens]).to eq [['+', '+']]
      expect(results[:remaining_code]).to eq " 2\n  end"
    end
  end
end

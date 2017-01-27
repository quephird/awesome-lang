require_relative '../../readers/identifier'

describe Readers::Identifier do
  let(:identifier_reader) { Readers::Identifier.new }
  let(:initial_results) do
    {
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a keyword' do
    it 'should properly parse out def' do
      results = identifier_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq [[:DEF, 'def']]
    end

    it 'should strip the keyword from the beginning of the string' do
      results = identifier_reader.read("def Foo", initial_results)
      expect(results[:remaining_code]).to eq " Foo"
    end
  end

  context 'input string begins with an identifier' do
    it 'should properly parse out def' do
      results = identifier_reader.read("foo\n  42", initial_results)
      expect(results[:tokens]).to eq [[:IDENTIFIER, 'foo']]
    end

    it 'should strip the identifier from the beginning of the string' do
      results = identifier_reader.read("foo\n  42", initial_results)
      expect(results[:remaining_code]).to eq "\n  42"
    end
  end

  context 'input string does not begin with a keyword nor an identifier' do
    it 'should not parse anything' do
      results = identifier_reader.read('Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = identifier_reader.read('Foo', initial_results)
      expect(results[:remaining_code]).to eq 'Foo'
    end
  end
end

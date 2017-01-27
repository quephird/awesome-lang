require_relative '../../readers/string'

describe Readers::String do
  let(:string_reader) { Readers::String.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a string literal' do
    it 'should properly parse the string' do
      results = string_reader.read("\"a string\"   ", initial_results)
      expect(results[:tokens]).to eq [[:STRING, 'a string']]
    end

    it 'should strip the string literal from the beginning of the string' do
      results = string_reader.read("\"a string\"   ", initial_results)
      expect(results[:remaining_code]).to eq "   "
    end
  end

  context 'input string does not begin with a string literal' do
    it 'should not parse anything' do
      results = string_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = string_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

require_relative '../../readers/number'

describe Readers::Number do
  let(:number_reader) { Readers::Number.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a number' do
    it 'should properly parse the number' do
      results = number_reader.read("42\nend", initial_results)
      expect(results[:tokens]).to eq [[:NUMBER, 42]]
    end

    it 'should strip the number from the beginning of the string' do
      results = number_reader.read("42\nend", initial_results)
      expect(results[:remaining_code]).to eq "\nend"
    end
  end

  context 'input string does not begin with a number' do
    it 'should not parse anything' do
      results = number_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = number_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

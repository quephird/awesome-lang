require_relative '../../readers/space'

describe Readers::Space do
  let(:space_reader) { Readers::Space.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a space' do
    it 'should not parse anything' do
      results = space_reader.read("  42", initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should strip the one space from the beginning of the string' do
      results = space_reader.read("  42", initial_results)
      expect(results[:remaining_code]).to eq " 42"
    end
  end

  context 'input string does not begin with a space' do
    it 'should not parse anything' do
      results = space_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = space_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

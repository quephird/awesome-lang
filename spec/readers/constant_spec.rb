require_relative '../../readers/constant'

describe Readers::Constant do
  let(:constant_reader) { Readers::Constant.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a constant' do
    it 'should properly parse the constant' do
      results = constant_reader.read("SomeConstant\n  42", initial_results)
      expect(results[:tokens]).to eq [[:CONSTANT, 'SomeConstant']]
    end

    it 'should strip the constant from the beginning of the string' do
      results = constant_reader.read("SomeConstant\n  42", initial_results)
      expect(results[:remaining_code]).to eq "\n  42"
    end
  end

  context 'input string does not begin with a constant' do
    it 'should not parse anything' do
      results = constant_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = constant_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

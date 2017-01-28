require_relative '../../readers/operator'

describe Readers::Operator do
  let(:operator_reader) { Readers::Operator.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with an operator' do
    it 'should properly parse the operator' do
      results = operator_reader.read("== 42", initial_results)
      expect(results[:tokens]).to eq [['==', '==']]
    end

    it 'should strip the operator from the beginning of the string' do
      results = operator_reader.read("== 42", initial_results)
      expect(results[:remaining_code]).to eq " 42"
    end
  end

  context 'input string does not begin with a constant' do
    it 'should not parse anything' do
      results = operator_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = operator_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

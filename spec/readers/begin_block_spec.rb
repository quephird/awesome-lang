require_relative '../../readers/begin_block'

describe Readers::BeginBlock do
  let(:begin_block_reader) { Readers::BeginBlock.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  context 'input string begins with a new block' do
    it 'should properly parse the block beginning' do
      results = begin_block_reader.read(":\n  def foo", initial_results)
      expect(results[:tokens]).to eq [[:INDENT, 2]]
    end

    it 'should strip the constant from the beginning of the string' do
      results = begin_block_reader.read(":\n  def foo", initial_results)
      expect(results[:remaining_code]).to eq "def foo"
    end
  end

  context 'input string does not begin with a new block' do
    it 'should not parse anything' do
      results = begin_block_reader.read('def Foo', initial_results)
      expect(results[:tokens]).to eq []
    end

    it 'should return the string untouched as remainining code' do
      results = begin_block_reader.read('def Foo', initial_results)
      expect(results[:remaining_code]).to eq 'def Foo'
    end
  end
end

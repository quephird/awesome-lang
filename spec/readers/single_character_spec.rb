require_relative '../../readers/single_character'

describe Readers::SingleCharacter do
  let(:space_reader) { Readers::SingleCharacter.new }
  let(:initial_results) do
    {
      match_found: false,
      tokens: [],
      current_indent: 0,
      indent_stack: []
    }
  end

  it 'should parse a single character operator' do
    results = space_reader.read("+ 3", initial_results)
    expect(results[:tokens]).to eq [['+', '+']]
  end

  it 'should parse a left parenthesis' do
    results = space_reader.read("(42)", initial_results)
    expect(results[:tokens]).to eq [['(', '(']]
  end
end

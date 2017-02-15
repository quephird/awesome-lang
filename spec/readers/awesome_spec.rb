require_relative '../../readers/begin_block'
require_relative '../../readers/constant'
require_relative '../../readers/identifier'
require_relative '../../readers/indent'
require_relative '../../readers/number'
require_relative '../../readers/operator'
require_relative '../../readers/single_character'
require_relative '../../readers/space'
require_relative '../../readers/string'
require_relative '../../readers/sequence'
require_relative '../../readers/awesome'

describe Readers::Awesome do
  let(:awesome_reader) { Readers::Awesome.new }
  let(:example_code) {
    <<~EXAMPLE
      if 1:
        if 2:
          print("...")
          if false:
            pass
          print("done!")
        2

      print "The End"
    EXAMPLE
  }
  context 'example code from book' do
    tokens = [
      [:IF, "if"], [:NUMBER, 1],
        [:INDENT, 2],
        [:IF, "if"],
        [:NUMBER, 2],
        [:INDENT, 4],
          [:IDENTIFIER, "print"],
          ["(", "("],
          [:STRING, "..."],
          [")", ")"],
          [:NEWLINE, "\n"],
          [:IF, "if"],
          [:FALSE, "false"],
          [:INDENT, 6],
            [:IDENTIFIER, "pass"],
          [:DEDENT, 4],
          [:NEWLINE, "\n"],
          [:IDENTIFIER, "print"],
          ["(", "("],
          [:STRING, "done!"],
          [")", ")"],
        [:DEDENT, 2],
        [:NEWLINE, "\n"],
        [:NUMBER, 2],
      [:DEDENT, 0],
      [:NEWLINE, "\n"],
      [:NEWLINE, "\n"],
      [:IDENTIFIER, "print"],
      [:STRING, "The End"],
    ]
    it 'should properly parse the code' do
      results = awesome_reader.read(example_code)
      expect(results[:tokens]).to eq tokens
    end
  end
end

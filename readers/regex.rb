module Readers
  class Regex
    # This class is used by most of the specialized readers.
    # The constructor expects to get passed a regex used to
    # match and capture a pattern at the beginning of the
    # the stream/string being processed, and a lambda
    # which is called if a match is found, which modifies then
    # returns the initial results structure passed to it. If the
    # match fails then it returns with the :match_found set to
    # false.
    def initialize(regex, &match_handler)
      @regex = regex
      @match_handler = match_handler
    end

    def read(stream, results)
      chunk = stream[@regex, 1]

      if !chunk.nil?
        @match_handler.call(chunk, stream, results)
        results[:match_found] = true
      else
        results[:match_found] = false
        results[:remaining_code] = stream
      end
      results
    end
  end
end

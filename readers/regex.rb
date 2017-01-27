module Readers
  class Regex
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

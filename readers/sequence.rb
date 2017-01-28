module Readers
  class Sequence
    def initialize(readers)
      @readers = readers
    end

    def read(stream, results)
      readers = @readers

      for reader in readers
        test_results = reader.read(stream, results)

        if test_results[:match_found]
          # # We got a match, stop looping.
          results = test_results
          break
        end
      end

      results
    end
  end
end

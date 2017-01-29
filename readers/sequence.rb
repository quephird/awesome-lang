module Readers
  class Sequence
    # This class is initialized with a set of regex-based
    # readers, and when called to read the stream/string,
    # will iterate through them. It will either find a match,
    # and return the results structure processed by the
    # correspondent reader, set the :match_found key, or return
    # the results untouched. It should be noted that it will
    # run throught this set of readers only once.
    def initialize(readers)
      @readers = readers
    end

    def read(stream, results)
      readers = @readers

      for reader in readers
        test_results = reader.read(stream, results)

        if test_results[:match_found]
          results = test_results
          break
        end
      end

      results
    end
  end
end

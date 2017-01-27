module Readers
  class Sequence
    def initialize(readers)
      @readers = readers
    end

    def read(stream, results)
      readers = @readers

      loop do
        if readers.empty?
          # We've gone through all the readers
          break
        else
          # Attempt to read with the first reader in sequence of readers.
          (reader, *rest_readers) = readers

          # Read with the first reader.
          test_results = reader.read(stream, results)

          if test_results[:match_found]
            # We got a match; empty out the readers array so we stop looping.
            readers = []
            results = test_results
          else
            # We didn't get a match; move onto the next reader, preserving the results.
            readers = rest_readers
          end
        end
      end

      results
    end
  end
end

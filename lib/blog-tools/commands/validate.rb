# frozen_string_literal: true

module BlogTools
  module Commands
    # Validate contains all commands relating to validating posts
    class Validate < Thor
      desc 'TITLE', 'Validate posts'

      def default(test)
        puts test
      end
    end
  end
end

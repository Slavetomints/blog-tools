# frozen_string_literal: true

module BlogTools
  module Commands
    # Config deals with all commands that configure how blog-tools works
    class Config < Thor
      desc 'TITLE', 'Configure blog-tools'

      def default(test)
        puts test
      end
    end
  end
end

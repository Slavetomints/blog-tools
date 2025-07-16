# frozen_string_literal: true

module BlogTools
  module Commands
    # Frontmatter handles all commands relating to creating
    # and editing frontmatter
    class Frontmatter < Thor
      desc 'TITLE', 'Generate frontmatter for a blog post'

      def default(test)
        puts test
      end
    end
  end
end

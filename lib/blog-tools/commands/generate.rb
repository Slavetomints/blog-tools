# frozen_string_literal: true

module BlogTools
  module Commands
    # Generate handles all of the subcommands related to generating posts
    class Generate < Thor
      desc 'TITLE', 'Generate a new blog post'

      def default(title)
        puts "Generating post titled: #{title}"
      end
    end
  end
end

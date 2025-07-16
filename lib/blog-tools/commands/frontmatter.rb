module BlogTools
  module Commands
    class Frontmatter < Thor
      desc "TITLE", "Generate frontmatter for a blog post"

      def default(test)
        puts test
      end
    end
  end
end
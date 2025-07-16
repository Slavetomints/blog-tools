module BlogTools
  module Commands
    class Generate < Thor
      desc "TITLE", "Generate a new blog post"

      def default(title)
        puts "Generating post titled: #{title}"
      end
    end
  end
end
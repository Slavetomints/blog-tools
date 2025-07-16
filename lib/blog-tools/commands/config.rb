module BlogTools
  module Commands
    class Config < Thor
      desc "TITLE", "Configure blog-tools"

      def default(test)
        puts test
      end
    end
  end
end
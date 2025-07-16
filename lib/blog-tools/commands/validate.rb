module BlogTools
  module Commands
    class Validate < Thor
      desc "TITLE", "Validate posts"

      def default(test)
        puts test
      end
    end
  end
end
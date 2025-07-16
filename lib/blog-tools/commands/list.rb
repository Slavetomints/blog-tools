module BlogTools
  module Commands
    class List < Thor
      desc "TITLE", "Create and edit lists of posts to make"

      def default(test)
        puts test
      end
    end
  end
end
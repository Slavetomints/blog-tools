# frozen_string_literal: true

module BlogTools
  module Commands
    # List handles all of the subcommands dealing with makes, editing, and
    # creating lists of blog post ideas
    class List < Thor
      @list_file =

        desc 'create NAME', 'Create a list'
      def create(_name)
        nil unless list
      end
      desc 'add', 'Add a post idea to a list'
      desc 'remove', 'Remove a post idea from a list'
      desc 'list', 'View all post ideas in a list'
    end
  end
end

# frozen_string_literal: true

require_relative '../storage'

module BlogTools
  module Commands
    # List handles all of the subcommands dealing with makes, editing, and
    # creating lists of blog post ideas
    class List < Thor
      default_task :list

      def initialize(*args)
        super
        @lists = Storage.read_lists || {}
      end

      desc 'list LIST', 'View all post ideas in a list'
      def list(list)
        return puts('[!] List not found') unless @lists[list]

        puts list.upcase
        @lists[list][:posts].each_key do |item|
          puts "- #{item}"
        end
      end

      desc 'create NAME', 'Create a list'
      def create(name)
        return puts('[!] List not found') unless @lists[list]

        @lists[name] = { posts: {} }
        Storage.write_lists(@lists)
        puts "[✓] Created list: #{name}"
      end

      desc 'add POST', 'Add a post idea to a list'
      def add(list, post_name)
        return puts('[!] List not found') unless @lists[list]

        @lists[list][:posts][post_name] = { completed: false, in_progress: false }
        puts "[✓] Added #{post_name} to #{list} list"
        Storage.write_lists(@lists)
      end

      desc 'remove LIST', 'Remove a post idea from a list'
      def remove(list)
        return puts('[!] List not found') unless @lists[list]

        puts "[?] Are you sure you want to delete the '#{list}' list?"
        print "[?] This action cannot be undone. Proceed? (y/N)\n> "
        input = $stdin.gets.chomp.strip

        case input.downcase
        when 'y'
          @lists.delete(list)
          Storage.write_lists(@lists)
          puts "[✓] Deleted '#{list}' list"
        when 'n', ''
          puts '[i] Cancelled.'
        else
          puts '[!] Invalid input. Not deleting.'
        end
      end
    end
  end
end

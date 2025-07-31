# frozen_string_literal: true

require 'colorize'

require_relative '../storage'

module BlogTools
  module Commands
    # BlogTools::Commands::Lists handles post lists
    #
    # List handles all of the subcommands dealing with making, editing, and
    # creating lists of blog post ideas
    #
    # @example Show all posts in a list
    #   blog-tools lists show list
    #
    # @example Remove a post from a list
    #   blog-tools lists remove list post
    #
    # @see BlogTools::CLI
    # @see BlogTools::Storage
    class Lists < Thor
      # Initializes the `lists` command with stored list data.
      #
      # This constructor is automatically called by Thor when the `lists` subcommand is invoked.
      # It loads existing lists from storage into the `@lists` instance variable.
      #
      # @param [Array<String>] args Command-line arguments passed to the subcommand from Thor
      # @see BlogTools::Storage::LISTS_FILE
      def initialize(*args)
        super
        @lists = Storage.read_lists || {}
      end

      desc 'show LIST', 'View all posts in a list'
      method_option :completed, type: :boolean, default: false, desc: 'Show only completed posts'
      method_option :in_progress, type: :boolean, default: false, desc: 'Show only in-progress posts'
      method_option :status, type: :boolean, default: false, desc: 'Show post status as well'
      # Shows all posts that are in a list
      #
      # This command reads the list from the `@lists` variable, and then shows it
      # You can customize what it shows (completed/uncompleted), and if it shows
      # the status of the post.
      #
      # @param [String] list The name of the list
      # @option options [Boolean] :completed Show only posts that are completed.
      # @option options [Boolean] :in_progress Show only posts that are in progress.
      # @option options [Boolean] :status Show the status of the posts in the list.
      # @example Basic usage
      #   ❯ blog-tools lists show example
      #   EXAMPLE
      #   - example-post-1
      #   - example-post-2
      #   - example-post-3
      #   - example-post-4
      #   - example-post-5
      #
      # @example using the `--status` flag
      #   ❯ blog-tools lists show example --status
      #   EXAMPLE
      #   - [✓] example-post-1
      #   - [~] example-post-2
      #   - [✓] example-post-3
      #   - [ ] example-post-4
      #   - [ ] example-post-5
      #
      # @example using the `--completed` flag
      #   ❯ blog-tools lists show example --completed
      #   EXAMPLE
      #   - example-post-1
      #   - example-post-3
      #
      # @example using the `--in-progress` flag
      #   ❯ blog-tools lists show example --in-progress
      #   EXAMPLE
      #   - example-post-2
      #
      # @return [Nil]
      def show(list)
        return puts '[!] List not found'.colorize(:red) unless @lists[list]

        puts list.upcase
        @lists[list][:posts].each do |item, data|
          next if options[:completed] && !data[:completed]
          next if options[:in_progress] && !data[:in_progress]

          if options[:status]
            status =
              if data[:completed]
                '[✓]'
              elsif data[:in_progress]
                '[~]'
              else
                '[ ]'
              end
            puts "- #{status} #{item}"
          else
            puts "- #{item}"
          end
        end
      end

      desc 'create NAME', 'Create a list'
      # Creates a new list
      #
      # This command takes in a name for a list, and then creates a new list in
      # the lists configuration file.
      #
      # @param [String] list The name of the list
      # @example creating a new list
      #   ❯ blog-tools lists create test
      #   [✓] Created list: test
      #
      # @return [Nil]
      def create(name)
        @lists[name] = { posts: {} }
        Storage.write_lists(@lists)
        puts "[✓] Created list: #{name}".colorize(:green)
      end

      desc 'add LIST POST', 'Add a post to a list'
      # Adds a post to a list
      #
      # This command takes the name of a list and the name of a post to be added.
      # Assuming that the list exists, it will add the post to the list, and
      # write the result to the list configuration file
      #
      # @param [String] list The name of the list
      # @param [String] post_name The name of the post
      # @example Adding a post to a list
      #   ❯ blog-tools lists add test example
      #   [✓] Added example to test list
      # @return [Nil]
      def add(list, post_name)
        return puts '[!] List not found'.colorize(:red) unless @lists[list]

        @lists[list][:posts][post_name] = { completed: false, in_progress: false }
        Storage.write_lists(@lists)
        puts "[✓] Added #{post_name} to #{list} list".colorize(:green)
      end

      desc 'delete LIST', 'Delete a list'
      # Deletes a list
      #
      # This command takes in the name of a list and deletes it from the lists
      # configuration file. It requires user input to confirm the deletion of
      # the list. Once the user gives confirmation, it edits the `@lists`
      # variable and writes it back to the lists configuration file.
      #
      # @param [String] list The name of the list
      # @example Deleting a list
      #   ❯ blog-tools lists delete test
      #   [?] Are you sure you want to delete the 'test' list?
      #   [?] This action cannot be undone. Proceed? (y/N)
      #   > y
      #   [✓] Deleted 'test' list
      # @return [Nil]
      def delete(list)
        return puts '[!] List not found'.colorize(:red) unless @lists[list]

        puts "[?] Are you sure you want to delete the '#{list}' list?".colorize(:yellow)
        print "[?] This action cannot be undone. Proceed? (y/N)\n> ".colorize(:yellow)
        input = $stdin.gets.chomp.strip

        case input.downcase
        when 'y'
          @lists.delete(list)
          Storage.write_lists(@lists)
          puts "[✓] Deleted '#{list}' list".colorize(:green)
        when 'n', ''
          puts '[i] Cancelled deletion.'.colorize(:blue)
        else
          puts '[!] Invalid input. Not deleting.'.colorize(:red)
        end
      end

      desc 'remove LIST POST', 'Remove a post from a list'
      # Removes a post from a list
      #
      # This command take in both a list name and a post name, and then removes
      # the post from the list. It requires user confirmation in order to make
      # the deletion. Once the user confirms, it edits the `@lists` variable,
      # and writes it to the lists configuration file.
      #
      # @param [String] list The name of the list
      # @param [String] post_name The name of the post
      # @example
      #   ❯ blog-tools lists remove example example-post-1
      #   [?] Are you sure you want to delete the post 'example-post-1'?
      #   [?] This action cannot be undone. Proceed? (y/N)
      #   > y
      #   [✓] Deleted 'example-post-1' post
      # @return [Nil]
      def remove(list, post_name)
        return puts '[!] List not found'.colorize(:red) unless @lists[list]

        puts "[?] Are you sure you want to delete the post '#{post_name}'?".colorize(:yellow)
        print "[?] This action cannot be undone. Proceed? (y/N)\n> ".colorize(:yellow)
        input = $stdin.gets.chomp.strip

        case input.downcase
        when 'y'
          @lists[list][:posts].delete(post_name)
          Storage.write_lists(@lists)
          puts "[✓] Deleted '#{post_name}' post".colorize(:green)
        when 'n', ''
          puts '[i] Cancelled deletion.'.colorize(:blue)
        else
          puts '[!] Invalid input. Not deleting.'.colorize(:red)
        end
      end

      desc 'update LIST POST', 'Update the status of a blog post idea'
      method_option :completed, type: :boolean, default: false, desc: 'Mark as complete'
      method_option :in_progress, type: :boolean, default: false, desc: 'Mark as in progress'
      method_option :path, type: :string, desc: 'Path to the post contents'
      method_option :tags, type: :array
      # Updates aspects of a post in a list
      #
      # This command takes a list and post, and requires a flag to be set to
      # run. If no flag is set it will return. The set flag and the parameter
      # with the flag are added into the lists configuration file under the
      # post.
      #
      # @param [String] list The name of the list
      # @param [String] post_name The name of the post
      # @option options [Boolean] :completed This marks a post as completed
      # @option options [Boolean] :in_progress This marks a post as in progress
      # @option options [String] :path This specifies the path to the post's contents
      # @option options [Array] :tags This adds tags to the post in the list
      # @example Using the `--completed` flag.
      #   ❯ blog-tools lists update example example-post-1 --completed
      #   [✓] Marked 'example-post-1' as complete
      # @example Using the `--in-progress` flag.
      #   ❯ blog-tools lists update example example-post-2 --in-progress
      #   [✓] Marked 'example-post-2' as in progress
      # @example Using the `--path` flag.
      #   ❯ blog-tools lists update example example-post-1 --path ~/documents/writeup.md
      #   The post content is located at: /home/slavetomints/documents/writeup.md
      # @example Using the `--tags` flag.
      #   ❯ blog-tools lists update example example-post-3 --tags 1 2 3
      #   Added the following tags to the post: ["1", "2", "3"]
      # @return [Nil]
      def update(list, post_name)
        unless options[:completed] || options[:in_progress] || options[:tags] || options[:path]
          return puts '[!] Please specify a status. Type "blog-tools lists help update" for more info.'.colorize(:red)
        end
        return puts '[!] List not found'.colorize(:red) unless @lists[list]
        return puts '[!] Post not found'.colorize(:red) unless @lists[list][:posts].key?(post_name)

        post = @lists[list][:posts][post_name]

        if options[:completed]
          if post[:completed]
            puts '[!] Post already marked as complete'.colorize(:redd)
          else
            post[:completed] = true
            puts "[✓] Marked '#{post_name}' as complete".colorize(:green)
          end
        end

        if options[:in_progress]
          if post[:in_progress]
            puts '[!] Post already marked as in progress'.colorize(:red)
          else
            post[:in_progress] = true
            puts "[✓] Marked '#{post_name}' as in progress".colorize(:green)
          end
        end
        post[:tags] = options[:tags] if options[:tags]
        puts "Added the following tags to the post: #{options[:tags]}" if options[:tags]
        post[:path] = options[:path] if options[:path]
        puts "The post content is located at: #{options[:path]}" if options[:path]

        Storage.write_lists(@lists)
        nil
      end
    end
  end
end

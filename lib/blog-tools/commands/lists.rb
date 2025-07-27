# frozen_string_literal: true

require 'colorize'

require_relative '../storage'

module BlogTools
  module Commands
    # List handles all of the subcommands dealing with makes, editing, and
    # creating lists of blog post ideas
    #
    # TODO option to add file path to the post
    class Lists < Thor
      def initialize(*args)
        super
        @lists = Storage.read_lists || {}
      end

      desc 'list LIST', 'View all posts in a list'
      method_option :completed, type: :boolean, default: false, desc: 'Show only completed posts'
      method_option :in_progress, type: :boolean, default: false, desc: 'show only in-progress posts'
      method_option :status, type: :boolean, default: false, desc: 'Show post status as well'
      # TODO: all option for all information about the post
      def list(list)
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
      def create(name)
        @lists[name] = { posts: {} }
        Storage.write_lists(@lists)
        puts "[✓] Created list: #{name}".colorize(:green)
      end

      desc 'add LIST POST', 'Add a post to a list'
      def add(list, post_name)
        return puts '[!] List not found'.colorize(:red) unless @lists[list]

        @lists[list][:posts][post_name] = { completed: false, in_progress: false }
        puts "[✓] Added #{post_name} to #{list} list".colorize(:green)
        Storage.write_lists(@lists)
      end

      desc 'delete LIST', 'Delete a list'
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
      end

      private

      def show_statuses
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
  end
end

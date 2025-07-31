# frozen_string_literal: true

require 'colorize'
require 'erb'
require 'date'
require_relative '../storage'

module BlogTools
  module Commands
    # BlogTools::Commands::Generate handles post generation
    #
    # It is a Thor-based CLI command set for generating blog posts
    # It supports options like specifying a custom template, defining the author,
    # setting tags, and defining the post content.
    #
    # @example Generate a basic post
    #   blog-tools generate post "My post Title"
    #
    # @example Generate a post with tags and author
    #   blog-tools generate post "My post Title" --tags ruby blog --author username
    #
    # @see BlogTools::CLI
    # @see Storage::CONFIG_FILE
    # @see Storage::TEMPLATES_DIR
    class Generate < Thor
      desc 'post TITLE', 'Generate a new blog post'
      method_option :template, type: :string, desc: 'Specify a template file'
      method_option :tags, type: :array, desc: 'Specify tags (space separated)'
      method_option :author, type: :string, desc: 'Specify author'
      method_option :output, type: :string, desc: 'Output directory'
      method_option :content, type: :string, desc: 'Path to content of post'

      # Generates a new blog post from a template
      #
      # This command uses ERB templates to render a new post from a template
      # You can customize the template, author, tags, and content, as well as
      # where to save the file to.
      #
      # @param [String] title The title of the post
      # @option options [String] :template Path to the ERB template
      # @option options [Array<String>] :tags Tags to associate with the post
      # @option options [String] :author Name of the author (overrides default in config file)
      # @option options [String] :output Output directory (default: current)
      # @option options [String] :content Path to file containing the post content
      # @example
      #  ❯ blog-tools generate post example
      #  [✓] Post generated at example.md
      # @return [Nil]
      # @see ::ERB
      # @see ::Date
      # @see String#Colorize
      def post(title)
        config = File.exist?(Storage::CONFIG_FILE) ? YAML.load_file(Storage::CONFIG_FILE) : {}

        template_file = options[:template] || config['default_template'] || 'post.md'
        template_path = File.expand_path(File.join(Storage::TEMPLATES_DIR + template_file))

        return puts "[!] Template file not found: #{template_path}".colorize(:red) unless File.exist?(template_path)

        template = File.read(template_path)
        renderer = ERB.new(template)

        result = renderer.result_with_hash(
          title: title,
          date: Date.today.to_s,
          author: options[:author] || config['author'] || ENV['USER'] || 'unknown',
          tags: options[:tags] || config['tags'] || [],
          content: options[:content] ? File.read(File.expand_path(options[:content])) : ''
        )

        dir_path = "#{options[:output]}/"
        output_filename = if options[:output]
                            "#{dir_path}#{title}.md"
                          else
                            "#{title.downcase.strip.gsub(/\s+/,
                                                         '_')}.md"
                          end
        File.write(output_filename, result)

        puts "[✓] Post generated at #{output_filename}".colorize(:green)
      end
    end
  end
end

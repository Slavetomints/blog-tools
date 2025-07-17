# frozen_string_literal: true

require 'erb'
require 'date'
require_relative '../storage'

module BlogTools
  module Commands
    # Generate handles all of the subcommands related to generating posts
    class Generate < Thor
      desc 'post TITLE', 'Generate a new blog post'
      method_option :template, type: :string, desc: 'Specify a template file'
      method_option :tags, type: :array, desc: 'Specify tags (space separated)'
      method_option :author, type: :string, desc: 'Specify author'
      method_option :output, type: :string, desc: 'Output path or filename (default: title.md)'
      method_option :content, type: :string, desc: 'Path to content of post'
      def post(title)
        config = File.exist?(Storage::CONFIG_FILE) ? YAML.load_file(Storage::CONFIG_FILE) : {}

        template_file = options[:template] || config['default_template'] || 'post.md'
        template_path = File.expand_path(File.join(Storage::TEMPLATES_DIR + template_file))

        return puts("[!] Template file not found: #{template_path}") unless File.exist?(template_path)

        template = File.read(template_path)
        renderer = ERB.new(template)

        result = renderer.result_with_hash(
          title: title,
          date: Date.today.to_s,
          author: options[:author] || config['author'] || ENV['USER'] || 'unknown',
          tags: options[:tags] || config['tags'] || [],
          content: options[:content] ? File.read(File.expand_path(options[:content])) : ''
        )

        output_filename = options[:output] || "#{title.downcase.strip.gsub(/\s+/, '_')}.md"
        File.write(output_filename, result)

        puts "[✓] Post generated at #{output_filename}"
      end
    end
  end
end

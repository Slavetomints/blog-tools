# frozen_string_literal: true

require 'colorize'
require 'fileutils'
require 'yaml'

module BlogTools
  # Handles paths and file initialization for blog-tools
  # configuration and templates.
  module Storage
    CONFIG_DIR            = ENV['BLOG_TOOLS_DIR'] || File.join(Dir.home, '.config', 'blog-tools')
    LISTS_FILE            = File.join(CONFIG_DIR, 'lists.yml')
    CONFIG_FILE           = File.join(CONFIG_DIR, 'config.yml')
    TEMPLATES_DIR         = File.join(CONFIG_DIR, 'templates/')
    DEFAULT_TEMPLATE_FILE = File.join(TEMPLATES_DIR, 'post.md')
    DEFAULT_TEMPLATE = <<~'MARKDOWN'
      ---
      title: "<%= title %>"
      date: <%= date %>
      author: <%= author %>
      tags: [<%= tags.map { |t| "\"#{t}\"" }.join(", ") %>]
      ---

      # <%= title %>

      <%= content %>
    MARKDOWN

    # Ensure required directories and files exist.
    def self.setup!
      create_directories
      create_lists_file
      create_config_file
      create_default_template
    end

    # Path to the config file
    def self.config_path
      CONFIG_FILE
    end

    def self.create_directories
      FileUtils.mkdir_p(CONFIG_DIR)
      FileUtils.mkdir_p(TEMPLATES_DIR)
    end

    def self.create_lists_file
      FileUtils.touch(LISTS_FILE) unless File.exist?(LISTS_FILE)
    end

    def self.write_lists(data)
      File.write(LISTS_FILE, data.to_yaml)
    end

    def self.read_lists
      return {} unless File.exist?(LISTS_FILE)

      data = YAML.safe_load_file(LISTS_FILE, permitted_classes: [Symbol, Date, Time], aliases: true)
      data.is_a?(Hash) ? data : {}
    rescue Psych::SyntaxError => e
      warn "[!] Failed to parse lists.yml: #{e.message}".colorize(:red)
      {}
    end

    def self.create_config_file
      return if File.exist?(CONFIG_FILE)

      FileUtils.mkdir_p(File.dirname(CONFIG_FILE))

      puts '[!] No configuration file found, generating now...'.colorize(:red)

      default_config = {
        'author' => ENV['USER'] || 'changeme',
        'default_template' => 'post.md',
        'tags' => ['blog']
      }

      File.write(CONFIG_FILE, default_config.to_yaml)
    end

    def self.create_default_template
      return unless Dir.empty?(TEMPLATES_DIR)

      File.write(DEFAULT_TEMPLATE_FILE, DEFAULT_TEMPLATE)
      puts "[+] Created default template: #{DEFAULT_TEMPLATE_FILE}"
    end
  end
end

# frozen_string_literal: true

require 'colorize'
require 'fileutils'
require 'yaml'

module BlogTools
  # BlogTools::Storage handles paths and file initialization for blog-tools
  # configuration and templates.
  #
  # It is the namespace for all of the locations of files and directories the CLI
  # accesses and writes to, as well as setting up the environment upon first run
  # or if the configuration directory was deleted.
  #
  # @see BlogTools::CLI
  module Storage
    # The location of the configuration directory. You can set your own with the
    # `BLOG_TOOLS_DIR` environment variable, otherwise it will be located at
    # `~/.config/blog-tools/`
    CONFIG_DIR            = ENV['BLOG_TOOLS_DIR'] || File.join(Dir.home, '.config', 'blog-tools')

    # The location of the file used for storing lists. It is named `lists.yml`
    # and put inside the configuration directory.
    LISTS_FILE            = File.join(CONFIG_DIR, 'lists.yml')

    # The locaion of the default configurations file. It is inside the
    # configuration directory
    CONFIG_FILE           = File.join(CONFIG_DIR, 'config.yml')

    # The directory where `blog-tools` looks to find templates for generating
    # posts. It is in the configuration directory.
    TEMPLATES_DIR         = File.join(CONFIG_DIR, 'templates/')

    # This is the location of the default template file used.
    DEFAULT_TEMPLATE_FILE = File.join(TEMPLATES_DIR, 'post.md')

    # This is the markdown for the default configuration file. It is put into
    # the file when `BlogTools::Storage.create_default_template` is run
    # @see BlogTools::Storage.create_default_template
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
    #
    # This method is used to completely setup the configuration environment
    # It creates the `~/.config/blog-tools` directory, and the files
    # and templates that are needed for the tool to run.
    #
    # @return [Nil]
    def self.setup!
      create_directories
      create_lists_file
      create_config_file
      create_default_template
    end

    # This method creates the configuration and templates directories.
    #
    # The directories are located at `~/.config/blog-tools`, and at
    # `~/.config/blog-tools/templates`
    #
    # @return [Array] An array of the directories created
    def self.create_directories
      FileUtils.mkdir_p(CONFIG_DIR)
      FileUtils.mkdir_p(TEMPLATES_DIR)
    end

    # Creates an empty lists file if it doesn't exist.
    #
    # @return [Array<String>, nil] The path to the file if created, otherwise nil.
    def self.create_lists_file
      FileUtils.touch(LISTS_FILE) unless File.exist?(LISTS_FILE)
    end

    # Writes the given data to the lists file in YAML format.
    #
    # @param data [Hash] The data to write.
    # @return [Integer] The number of bytes written to the file.
    def self.write_lists(data)
      File.write(LISTS_FILE, data.to_yaml)
    end

    # Reads and parses the lists file, returning its contents as a hash.
    #
    # If the file doesn't exist or contains invalid YAML, returns an empty hash.
    #
    # @return [Hash] Parsed YAML data from the lists file.
    def self.read_lists
      return {} unless File.exist?(LISTS_FILE)

      data = YAML.safe_load_file(LISTS_FILE, permitted_classes: [Symbol, Date, Time], aliases: true)
      data.is_a?(Hash) ? data : {}
    rescue Psych::SyntaxError => e
      warn "[!] Failed to parse lists.yml: #{e.message}".colorize(:red)
      {}
    end

    # Creates a default configuration file if one does not already exist.
    #
    # If the config file is missing, this method will:
    # - Print a warning message.
    # - Create the config directory if needed.
    # - Write a default config YAML file.
    #
    # @return [nil] Always returns nil.
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

    # Creates the default template file if the templates directory is empty.
    #
    # Writes the default post template to `post.md` and prints a success message.
    #
    # @return [nil] Always returns nil.
    def self.create_default_template
      return unless Dir.empty?(TEMPLATES_DIR)

      File.write(DEFAULT_TEMPLATE_FILE, DEFAULT_TEMPLATE)
      puts "[+] Created default template: #{DEFAULT_TEMPLATE_FILE}"
    end
  end
end

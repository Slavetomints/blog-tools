# frozen_string_literal: true

require 'thor'

require_relative 'commands/generate'
require_relative 'commands/validate'
require_relative 'commands/frontmatter'
require_relative 'commands/list'
require_relative 'commands/config'

require_relative 'storage'

# BlogTools is the main namespace for the blog-tools CLI application
# It contains submodules for command logic, file storage, and CLI Interfaces
module BlogTools
  # CLI handles all top-level commands for the blog-tools application
  # It delegates to subcommands
  class CLI < Thor
    def initialize(*args)
      super
    end

    desc 'generate TITLE', 'Create a new post'
    subcommand 'generate', Commands::Generate

    desc 'validate FILE', 'Validate a post'
    subcommand 'validate', Commands::Validate

    desc 'frontmatter', 'Front matter tools'
    subcommand 'frontmatter', Commands::Frontmatter

    desc 'list', 'List posts to create'
    subcommand 'list', Commands::List

    desc 'config', 'Configure blog-tools'
    subcommand 'config', Commands::Config
  end
end

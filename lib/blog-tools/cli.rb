# frozen_string_literal: true

require 'thor'

require_relative 'commands/generate'
require_relative 'commands/lists'
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
      Storage.setup!
    end

    desc 'generate', 'Create a new post'
    subcommand 'generate', Commands::Generate

    desc 'lists', 'Lists tools'
    subcommand 'lists', Commands::Lists

    desc 'config', 'Configure blog-tools'
    subcommand 'config', Commands::Config
  end
end

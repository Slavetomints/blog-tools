# frozen_string_literal: true

require 'thor'

require_relative 'commands/generate'
require_relative 'commands/lists'
require_relative 'commands/config'

require_relative 'storage'

# BlogTools is the main namespace for the blog-tools CLI application.
#
# It contains submodules for command logic, file storage, and CLI interfaces.
#
# @see BlogTools::CLI
module BlogTools
  # CLI is the entry point for the blog-tools command-line interface.
  #
  # It defines high-level commands like `generate`, `lists`, and `config`,
  # and delegates their functionality to the appropriate subcommands.
  #
  # This class inherits from Thor, a Ruby gem for building command-line interfaces.
  #
  # @example Running the CLI
  #   blog-tools generate my-post
  #   blog-tools lists show my-list
  #   blog-tools config
  #
  # @see Commands::Generate
  # @see Commands::Lists
  # @see Commands::Config
  class CLI < Thor
    # Creates a new CLI instance and initializes the storage backend.
    #
    # This is called automatically when the CLI is run.
    #
    # @param [Array] args arguments passed to Thor
    # @return [void]
    def initialize(*args)
      super
      Storage.setup!
    end

    # @!group Commands

    # Registers the `generate` subcommand.
    #
    # This command allows users to generate a new blog post interactively.
    #
    # @see Commands::Generate
    desc 'generate', 'Create a new post'
    subcommand 'generate', Commands::Generate

    # Registers the `lists` subcommand.
    #
    # This command allows users to manage post lists.
    #
    # @see Commands::Lists
    desc 'lists', 'Manage post lists'
    subcommand 'lists', Commands::Lists

    # Registers the `config` subcommand.
    #
    # This command allows users to configure blog-tools settings.
    #
    # @see Commands::Config
    desc 'config', 'Configure blog-tools'
    subcommand 'config', Commands::Config

    # @!endgroup
  end
end

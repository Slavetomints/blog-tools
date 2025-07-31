# frozen_string_literal: true

require_relative 'commands/config'
require_relative 'commands/generate'
require_relative 'commands/lists'

module BlogTools
  # The Commands module groups all the CLI subcommands for blog-tools together.
  #
  # Each subcommand implements a feature of the CLI, such as generating posts,
  # managing lists of future posts, and editing configurations for the tool.
  #
  # These subcommands are registered by the main BlogTools:CLI class.
  #
  # @see BlogTools::Commands::Generate
  # @see BlogTools::Commands::Lists
  # @see BlogTools::Commands::Config
  module Commands
    # This intentionally contains no logic. It exists to namespace the CLI commands
  end
end

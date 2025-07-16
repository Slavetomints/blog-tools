require "thor"

require_relative "commands/generate"
require_relative "commands/validate"
require_relative "commands/frontmatter"
require_relative "commands/list"
require_relative "commands/config"

module BlogTools
  class CLI < Thor
    
    def initialize(*args)
      super
    end

    desc "generate TITLE", "Create a new post"
    subcommand "generate", Commands::Generate

    desc "validate FILE", "Validate a post"
    subcommand "validate", Commands::Validate

    desc "frontmatter", "Front matter tools"
    subcommand "frontmatter", Commands::Frontmatter

    desc "list", "List posts"
    subcommand "list", Commands::List

    desc "config", "Configure blog-tools"
    subcommand "config", Commands::Config
  end
end
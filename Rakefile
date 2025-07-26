# frozen_string_literal: true

require 'rake'
require 'rubygems/package'
require 'bundler'
require 'bundler/gem_tasks'

require_relative 'lib/blog-tools/version'

GEM_NAME = 'blog-tools'
VERSION  = BlogTools::VERSION
TAG      = "v#{VERSION}".freeze

desc 'Tag, push to GitHub, build and push to RubyGems'
task :release do
  sh 'git add .'
  sh "git commit -m 'Release #{TAG}'" unless `git status --porcelain`.strip.empty?

  puts "Tagging #{TAG}..."
  sh "git tag #{TAG}"
  sh 'git push origin main'
  sh "git push origin #{TAG}"

  puts 'Building gem...'
  sh "gem build #{GEM_NAME}.gemspec"

  puts 'Pushing gem to RubyGems...'
  gem_file = "#{GEM_NAME}-#{VERSION}.gem"
  sh "gem push #{gem_file}"
end

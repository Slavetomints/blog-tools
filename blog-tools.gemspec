# frozen_string_literal: true

require_relative 'lib/blog-tools/version'

Gem::Specification.new do |s|
  s.name        = 'blog-tools'
  s.version     = BlogTools::VERSION
  s.summary     = 'CLI tools for managing blog posts'
  s.authors     = ['Slavetomints']
  s.email       = ['slavetomints@protonmail.com']
  s.files       = Dir['lib/**/*.rb'] + ['bin/blog-tools']
  s.license     = 'MIT'
  s.executables << 'blog-tools'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.4.0'
  s.add_dependency 'thor'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.homepage    = 'https://rubygems.org/gems/blog-tools'
  s.cert_chain  = ['certs/slavetomints.pem']
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME =~ /gem\z/
end

# frozen_string_literal: true

require 'pp'
require 'digest'
require 'spec_helper'
require 'thor'
require_relative '../../../lib/blog-tools/commands/generate'

RSpec.describe BlogTools::Commands::Generate do
  include FakeFS::SpecHelpers

  def template_setup
    FileUtils.mkdir_p(BlogTools::Storage::TEMPLATES_DIR)
    File.write(BlogTools::Storage::DEFAULT_TEMPLATE_FILE, BlogTools::Storage::DEFAULT_TEMPLATE)
  end
  describe '.post' do
    it 'creates a post using default command' do
      template_setup
      described_class.start(%w[post template])
      expect(File.readlines('template.md')).to include("title: \"template\"\n")
    end

    it 'creates a post with specific tags' do
      template_setup
      described_class.start(%w[post template_tags --tags=test test1])
      expect(File.readlines('template_tags.md')).to include("tags: [\"test\", \"test1\"]\n")
    end

    it 'creates a post with a specific author' do
      template_setup
      described_class.start(%w[post template_author --author=test])
      expect(File.readlines('template_author.md')).to include("author: test\n")
    end

    it 'creates a post to a specific place' do
      template_setup
      FileUtils.mkdir_p('test')
      described_class.start(%w[post template_output --output=test/template_output.md])
      expect(File).to exist('test/template_output.md')
    end

    it 'creates a post using content from a specified file' do
      template_setup
      File.write('input_content.md', 'Hello from the test content!')
      described_class.start(%w[post content_test --content=input_content.md --output=output.md])
      expect(File.read('output.md')).to include('Hello from the test content!')
    end
  end
end

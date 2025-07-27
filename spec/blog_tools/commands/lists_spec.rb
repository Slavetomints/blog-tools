# frozen_string_literal: true

require 'spec_helper'
require 'thor'
require_relative '../../../lib/blog-tools/commands/lists'

RSpec.describe BlogTools::Commands::Lists do
  include FakeFS::SpecHelpers

  before do
    allow(Dir).to receive(:home).and_return('/home/testuser')
  end

  def create_basic_list
    BlogTools::Storage.setup!
    described_class.start(%w[create test-list])
    described_class.start(%w[add test-list test-post1])
    described_class.start(%w[add test-list test-post2])
  end

  def create_complete_list
    BlogTools::Storage.setup!
    described_class.start(%w[create test-list])
    described_class.start(%w[add test-list test-post1])
    described_class.start(%w[add test-list test-post2])
    described_class.start(%w[update test-list test-post1 --completed])
  end

  def create_in_progress_list
    BlogTools::Storage.setup!
    described_class.start(%w[create test-list])
    described_class.start(%w[add test-list test-post1])
    described_class.start(%w[add test-list test-post2])
    described_class.start(%w[update test-list test-post1 --in-progress])
  end

  def create_all_list
    BlogTools::Storage.setup!
    described_class.start(%w[create test-list])
    described_class.start(%w[add test-list test-post1])
    described_class.start(%w[add test-list test-post2])
    described_class.start(%w[add test-list test-post3])
    described_class.start(%w[update test-list test-post1 --completed])
    described_class.start(%w[update test-list test-post2 --in-progress])
  end

  describe '.list' do
    it 'prints all posts' do
      create_basic_list
      expect do
        described_class.start(%w[list test-list])
      end.to output("TEST-LIST\n- test-post1\n- test-post2\n").to_stdout
    end

    it 'prints out all completed posts' do
      create_complete_list
      expect do
        described_class.start(%w[list test-list --completed])
      end.to output("TEST-LIST\n- test-post1\n").to_stdout
    end

    it 'prints out all in progress posts' do
      create_in_progress_list
      expect do
        described_class.start(%w[list test-list --in-progress])
      end.to output("TEST-LIST\n- test-post1\n").to_stdout
    end

    it 'prints out all posts with status' do
      create_all_list
      expect do
        described_class.start(%w[list test-list --status])
      end.to output("TEST-LIST\n- [✓] test-post1\n- [~] test-post2\n- [ ] test-post3\n").to_stdout
    end
  end

  describe '.create' do
    it 'creates a list' do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      expect(File.readlines(BlogTools::Storage::LISTS_FILE).join).to include("---\ntest-list:\n  :posts: {}\n")
    end
  end

  describe '.add' do
    it 'adds a post to a list' do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      described_class.start(%w[add test-list test-post])
      expect(File.read(BlogTools::Storage::LISTS_FILE)).to match(/^---\n\s*test-list:\n\s*:posts:\n\s*test-post:\n\s*:completed: false\n\s*:in_progress: false\n$/) # rubocop:disable Layout/LineLength
    end
  end

  describe '.delete' do
    it 'deletes a list when answered with "Y"' do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("Y\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).not_to have_key('test-list')
    end

    it 'deletes a list when answered with "y"' do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("y\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).not_to have_key('test-list')
    end

    it "doesn't delete a list when answered with `N`" do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("N\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).to have_key('test-list')
    end

    it "doesn't delete a list when answered with `n`" do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("n\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).to have_key('test-list')
    end

    it "doesn't delete a list when answered with [ENTER]" do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).to have_key('test-list')
    end

    it "doesn't delete a list when answered with an invalid input" do
      BlogTools::Storage.setup!
      described_class.start(%w[create test-list])
      allow($stdin).to receive(:gets).and_return("u\n")
      described_class.start(%w[delete test-list])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).to have_key('test-list')
    end
  end

  describe '.remove' do
    it 'removes a post when answered with "Y"' do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("Y\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).not_to have_key('test-post1')
    end

    it 'removes a post when answered with "y"' do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("y\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)).not_to have_key('test-post1')
    end

    it "doesn't remove a post when answered with `N`" do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("N\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)['test-list'][:posts]).to have_key('test-post1')
    end

    it "doesn't remove a post when answered with `n`" do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("n\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)['test-list'][:posts]).to have_key('test-post1')
    end

    it "doesn't remove a post when answered with [ENTER]" do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)['test-list'][:posts]).to have_key('test-post1')
    end

    it "doesn't remove a post when answered with an invalid input" do
      BlogTools::Storage.setup!
      create_basic_list
      allow($stdin).to receive(:gets).and_return("u\n")
      described_class.start(%w[remove test-list test-post1])
      expect(YAML.load_file(BlogTools::Storage::LISTS_FILE)['test-list'][:posts]).to have_key('test-post1')
    end
  end

  describe '.update' do
    it 'marks a post as complete' do
      BlogTools::Storage.setup!
      create_basic_list
      described_class.start(%w[update test-list test-post1 --completed])
      expect(File.readlines(BlogTools::Storage::LISTS_FILE).join).to include("---\ntest-list:\n  :posts:\n    test-post1:\n      :completed: true\n      :in_progress: false\n    test-post2:\n      :completed: false\n      :in_progress: false\n") # rubocop:disable Layout/LineLength
    end

    it 'marks a post as in progress' do
      BlogTools::Storage.setup!
      create_basic_list
      described_class.start(%w[update test-list test-post1 --in-progress])
      expect(File.readlines(BlogTools::Storage::LISTS_FILE).join).to include("---\ntest-list:\n  :posts:\n    test-post1:\n      :completed: false\n      :in_progress: true\n    test-post2:\n      :completed: false\n      :in_progress: false\n") # rubocop:disable Layout/LineLength
    end

    it 'adds the filepath to a post' do
      BlogTools::Storage.setup!
      create_basic_list
      described_class.start(%w[update test-list test-post1 --path=~/post.md])
      expect(File.readlines(BlogTools::Storage::LISTS_FILE).join).to include(':path: "~/post.md"')
    end

    it 'adds the tags to a post' do
      BlogTools::Storage.setup!
      create_basic_list
      described_class.start(%w[update test-list test-post1 --tags=test-tag])
      expect(File.readlines(BlogTools::Storage::LISTS_FILE).join).to include('test-tag')
    end
  end
end

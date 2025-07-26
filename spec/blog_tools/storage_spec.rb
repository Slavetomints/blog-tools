# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/blog-tools/storage'

RSpec.describe BlogTools::Storage do
  include FakeFS::SpecHelpers

  before do
    allow(Dir).to receive(:home).and_return('/home/testuser')
  end

  describe '.setup!' do
    it 'creates configuration file' do
      described_class.setup!

      expect(File).to exist(described_class::CONFIG_FILE)
    end

    it 'creates lists file' do
      described_class.setup!
      expect(File).to exist(described_class::LISTS_FILE)
    end

    it 'creates the default template' do
      described_class.setup!
      expect(File).to exist(described_class::DEFAULT_TEMPLATE_FILE)
    end
  end

  describe '.write_lists and .read_lists' do
    it 'writes and reads YAML data correctly' do
      test_data = { 'projects' => %w[blog-tools security-research] }

      described_class.setup!
      described_class.write_lists(test_data)

      result = described_class.read_lists
      expect(result).to eq(test_data)
    end

    it 'returns an empty hash if file is corrupted' do
      described_class.setup!
      File.write(described_class::LISTS_FILE, '!!!not yaml!!!')

      expect(described_class.read_lists).to eq({})
    end
  end

  describe '.create_config_file' do
    it 'writes default config if missing' do
      described_class.create_config_file
      config = YAML.load_file(described_class::CONFIG_FILE)
      expect(config['author']).to eq('changeme').or eq(ENV.fetch('USER', nil))
    end

    it 'does not overwrite existing config' do
      FileUtils.mkdir_p(File.dirname(described_class::CONFIG_FILE))
      File.write(described_class::CONFIG_FILE, { 'author' => 'minty' }.to_yaml)

      expect { described_class.create_config_file }.not_to(change do
        YAML.load_file(described_class::CONFIG_FILE)['author']
      end)
    end
  end

  describe '.create_default_template' do
    it 'creates a markdown template if templates dir is empty' do
      FileUtils.mkdir_p(described_class::TEMPLATES_DIR)

      expect do
        described_class.create_default_template
      end.to change { File.exist?(described_class::DEFAULT_TEMPLATE_FILE) }.from(false).to(true)
    end

    it 'does not overwrite templates if dir is not empty' do
      FileUtils.mkdir_p(described_class::TEMPLATES_DIR)
      File.write(File.join(described_class::TEMPLATES_DIR, 'custom.md'), 'hello')

      described_class.create_default_template
      expect(File).not_to exist(described_class::DEFAULT_TEMPLATE_FILE)
    end
  end
end

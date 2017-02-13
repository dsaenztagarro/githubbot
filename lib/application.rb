class Application
  class << self
    attr_reader :config

    def load(config_file)
      @config = YAML.load_file(config_file).freeze
    end
  end
end

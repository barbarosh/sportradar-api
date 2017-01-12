module Sportradar
  module Api
    class << self
      attr_accessor :config
    end

    def self.config
      @config ||= Config.new
    end

    # Set options via block
    def self.configure
      yield(config) if block_given?
    end

    class Config
      SPORTRADAR_API_HOST = 'api.sportradar.us'.freeze

      attr_accessor :api_timeout, :use_ssl, :format, :api_host, :fake_api_host

      def initialize
        @api_key = ENV['API_KEY']
        @api_host = ENV.fetch('SPORTRADAR_API_HOST', SPORTRADAR_API_HOST)
        @fake_api_host = ENV.fetch('SPORTRADAR_FAKE_API_HOST', SPORTRADAR_API_HOST)
        @api_timeout = ENV.fetch('SPORTRADAR_API_TIMEOUT', 15)
        @use_ssl = ENV.fetch('SPORTRADAR_API_USE_SSL', true)
        @format = ENV.fetch('SPORTRADAR_API_FORMAT', :xml).to_s
      end

      def reset
        @api_timeout = ENV.fetch('SPORTRADAR_API_TIMEOUT', 15)
        @use_ssl = ENV.fetch('SPORTRADAR_API_USE_SSL', true)
        @format = ENV.fetch('SPORTRADAR_API_FORMAT', :xml).to_s
      end
    end
  end
end


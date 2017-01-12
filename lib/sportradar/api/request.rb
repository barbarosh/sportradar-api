module Sportradar
  module Api
    class Request

      include HTTParty

      attr_reader :url, :headers, :timeout, :api_key

      def get(path, options={})
        base_setup(path, options)
        begin
          # puts url + "?api_key=#{api_key[:api_key]}" # uncomment for debugging
          response = self.class.get(url, headers: headers, query: options.merge(api_key), timeout: timeout)
        rescue Net::ReadTimeout, Net::OpenTimeout
          raise Sportradar::Api::Error::Timeout
        rescue EOFError
          raise Sportradar::Api::Error::NoData
        end
        return Sportradar::Api::Error.new(response.code, response.message, response) unless response.success?
        response
      end

      private

      def base_setup(path, options={})
        @url = set_base(path, options[:is_fake_api])
        @url += format unless options[:format] == 'none'
        @headers = set_headers unless options[:format] == 'none'
        @timeout = options.delete(:api_timeout) || Sportradar::Api.config.api_timeout
      end

      def set_base(path, is_fake_api = false)
        "#{!!Sportradar::Api.config.use_ssl ? 'https' : 'http'}://#{is_fake_api ? Sportradar::Api.config.fake_api_host : Sportradar::Api.config.api_host}#{path}"
      end

      def date_path(date)
        "#{date.year}/#{date.month}/#{date.day}"
      end

      def week_path(year, season, week)
        "#{ year }/#{ season }/#{ week }"
      end


      def format
        ".#{Sportradar::Api.config.format}" if Sportradar::Api.config.format
      end

      def set_headers
        { 'Content-Type' => "application/#{Sportradar::Api.config.format}", 'Accept' => "application/#{Sportradar::Api.config.format}" }
      end

      def api_key
        raise Sportradar::Api::Error::NoApiKey
      end
    end
  end
end


require 'test_helper'

class Sportradar::Api::ConfigTest < Minitest::Test

  def test_it_sets_and_clears_configurations
    Sportradar::Api.configure do |config|
      config.api_timeout = 3
      config.use_ssl = false
      config.fake_use_ssl = true
      config.format = :json
      config.api_host = 'test.local.host'
      config.fake_api_host = 'fake.local.host'
    end
    assert_equal Sportradar::Api.config.api_timeout, 3
    assert_equal Sportradar::Api.config.use_ssl, false
    assert_equal Sportradar::Api.config.fake_use_ssl, true
    assert_equal Sportradar::Api.config.format, :json
    assert_equal Sportradar::Api.config.api_host, 'test.local.host'
    assert_equal Sportradar::Api.config.fake_api_host, 'fake.local.host'

    Sportradar::Api.config.reset
    refute_equal Sportradar::Api.config.api_timeout, 3
    refute_equal Sportradar::Api.config.use_ssl, false
    refute_equal Sportradar::Api.config.fake_use_ssl, true
    refute_equal Sportradar::Api.config.format, :json
    assert_equal Sportradar::Api.config.api_host, 'api.sportradar.us'
    assert_equal Sportradar::Api.config.fake_api_host, 'api.sportradar.us'

  end


end

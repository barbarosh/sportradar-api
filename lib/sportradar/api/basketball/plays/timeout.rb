module Sportradar
  module Api
    module Basketball
      class Timeout < Play::Base
        attr_writer :media_timeout
        def display_type
          'Timeout'
        end
        def identifier
          "#{quarter}_#{clock_seconds}".to_i
        end
        def timeout?
          true
        end
        def full?
          true
        end
        def media_timeout?
          @media_timeout
        end
      end
    end
  end
end

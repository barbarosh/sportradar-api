module Sportradar
  module Api
    module Basketball
      class Nba
        class Scoring < Data
          attr_accessor :response, :api, :id, :home, :away, :scores

          def initialize(data, **opts)
            @api      = opts[:api]
            @game     = opts[:game]
            
            @scores = {
              1 => {},
              2 => {},
              3 => {},
              4 => {},
            }
            @id = data['id']
            
            update(data, **opts)
          end

          def update(data, source: nil, **opts)
            new_scores = case source
            when :box
              parse_from_box(data)
            when :pbp
              parse_from_pbp(data)
            when :summary
              parse_from_box(data)
            else
              if data['quarter']
                parse_from_pbp(data)
              elsif data['team']
                parse_from_box(data)
              else # schedule requests
                {}
              end
            end
            # parse data structure
            # handle data from team (all quarters)
            # handle data from quarter (both teams)
            # handle data from game?
            @scores.each { |k, v| v.merge!(new_scores.fetch(k, {})) }
          end

          def points(team_id)
            @score[team_id].to_i
          end


          private

          def parse_from_box(data)
            id = data.dig('team', 0, 'id')
            da = data.dig('team', 0, 'scoring', 'quarter')
            a = [da].compact.flatten(1).each { |h| h[id] = h.delete('points').to_i }
            id = data.dig('team', 1, 'id')
            da = data.dig('team', 1, 'scoring', 'quarter')
            b = [da].compact.flatten(1).each { |h| h[id] = h.delete('points').to_i }
            a.zip(b).map{ |a, b| [a['number'].to_i, a.merge(b)] }.sort{ |(a,_), (b,_)| a <=> b }.to_h
          rescue => e
            binding.pry
          end

          def parse_from_pbp(data)
            quarters = data['quarter'][1..-1]
            quarters = quarters[0] if quarters.is_a?(Array)
            data = quarters.map{|q| q['scoring'] }
            data.map.with_index(1) { |h, i| [i, { h.dig('home', 'id') => h.dig('home', 'points').to_i, h.dig('away', 'id') => h.dig('away', 'points').to_i }] }.to_h
          rescue => e
            {}
          end

          def parse_from_summary(data)
            # 
          end



          KEYS_PBP = ["xmlns", "id", "status", "coverage", "home_team", "away_team", "scheduled", "duration", "attendance", "lead_changes", "times_tied", "clock", "quarter", "scoring"]

          KEYS_BOX = ["xmlns", "id", "status", "coverage", "home_team", "away_team", "scheduled", "duration", "attendance", "lead_changes", "times_tied", "clock", "quarter", "team"]

        end
      end
    end
  end
end

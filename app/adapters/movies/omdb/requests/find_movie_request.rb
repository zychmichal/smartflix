# frozen_string_literal: true

# tu juz budowanie + raise wyjatek
module Movies
  module Omdb
    module Requests
      class FindMovieRequest
        include UriOmdbBuilder

        def find_movie_by_title_and_year(title, year = nil)
          request_uri = build_uri_by_title(title, year)
          res = Net::HTTP.get_response(request_uri)
          res if res.is_a?(Net::HTTPSuccess)
        end

        private

        def build_uri_by_title(title, year = nil)
          year.nil? ? build_uri(t: title) : build_uri(t: title, y: year)
        end
      end
    end
  end
end

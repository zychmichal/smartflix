# frozen_string_literal: true

module Movies
  module Omdb
    module ResponseStructs
      MovieSearchResult = Struct.new(:title, :year)

      MovieStruct = Struct.new(:title,
                               :year,
                               :rated,
                               :released,
                               :runtime,
                               :genre,
                               :director,
                               :writer,
                               :actors,
                               :plot,
                               :language,
                               :country,
                               :awards,
                               :poster,
                               :ratings,
                               :metascore,
                               :imdb_rating,
                               :imdb_votes,
                               :imdb_id,
                               :movie_type,
                               :dvd,
                               :box_office,
                               :production,
                               :website,
                               keyword_init: true)
    end
  end
end

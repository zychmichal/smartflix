# frozen_string_literal: true

MovieSearchResult = Struct.new(:title, :year)

MovieStruct = Struct.new(:title,
                         :created_at,
                         :updated_at,
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

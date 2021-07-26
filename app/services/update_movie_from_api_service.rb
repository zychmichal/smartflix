# frozen_string_literal: true

class UpdateMovieFromApiService
  def initialize(movie_adapter = Omdb::Client.new)
    @movie_adapter = movie_adapter
  end

  def update_movie(movie)
    updated_movie_attributes = @movie_adapter.find_by(title: movie.title, year: movie.year)
    movie.update!(updated_movie_attributes.to_h)
  end
end

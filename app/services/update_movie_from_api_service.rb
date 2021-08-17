# frozen_string_literal: true

class UpdateMovieFromApiService
  def initialize(movie_adapter = Movies::Omdb::Client.new)
    @movie_adapter = movie_adapter
  end

  # FIXME: try find another way to update movie (for example new field in movie record)
  def update_movie(movie)
    updated_movie_attributes = @movie_adapter.find_by(title: movie.title, year: movie.year)
    movie.touch if movie.update!(updated_movie_attributes.to_h)
  rescue Movies::MovieNotFoundError
    Rails.logger.warn(
      "Cannot find movie with title: #{movie.title} and year: #{movie.year.nil? ? 'without year' : movie.year}"
    )
  end
end

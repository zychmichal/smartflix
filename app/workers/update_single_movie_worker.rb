# frozen_string_literal: true

class UpdateSingleMovieWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform(movie_id)
    movie = Movie.find_by(id: movie_id)
    api.update_movie(movie)
  end

  private

  def api
    @api ||= UpdateMovieFromApiService.new
  end
end

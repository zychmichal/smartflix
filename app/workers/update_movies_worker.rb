# frozen_string_literal: true

class UpdateMoviesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform
    Movie.all.each { |movie| api.update_movie(movie) }
  end

  private

  def api
    @api ||= UpdateMovieFromApiService.new
  end
end

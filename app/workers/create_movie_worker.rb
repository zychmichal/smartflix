# frozen_string_literal: true

class CreateMovieWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform(title)
    api.add_movie_by_title_and_year(title)
  end

  private

  def api
    @api ||= AddMovieFromApiService.new
  end
end

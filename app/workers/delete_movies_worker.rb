# frozen_string_literal: true

class DeleteMoviesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform
    Movie.all.each { |movie| movie.delete if not_updated_since_two_days?(movie) }
  end

  private

  def not_updated_since_two_days?(movie)
    ((Time.zone.now - movie.updated_at) / 1.day) > 2
  end
end

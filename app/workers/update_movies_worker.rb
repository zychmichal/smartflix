# frozen_string_literal: true

class UpdateMoviesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform
    # INFO: parametr movie_id not movie object:
    # https://github.com/mperham/sidekiq/wiki/Best-Practices#1-make-your-jobs-input-small-and-simple
    # INFO: find each instead of each :
    # https://stackoverflow.com/questions/30010091/in-rails-whats-the-difference-between-find-each-and-where
    Movie.find_each { |movie| UpdateSingleMovieWorker.perform_async(movie.id) }
  end
end

# frozen_string_literal: true

class DeleteMoviesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'movies', retry: false

  def perform
    DeleteMoviesService.new.delete_outdated_movies
  end

end

# frozen_string_literal: true

class MoviesController < ApplicationController
  def show
    title = params[:title].titleize
    # TODO: full text search (gem pg_search)
    # https://pganalyze.com/blog/full-text-search-ruby-rails-postgres
    movie = Movie.find_by('title like ?', "%#{title}%")

    if movie
      render json: movie
    else
      CreateMovieWorker.perform_async(title)
      render json: { error: 'Sorry not found this title, but try again in few minutes' }.to_json,
             status: :not_found
    end
  end
end

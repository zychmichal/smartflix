# frozen_string_literal: true

class MoviesController < ApplicationController
  def show
    # przemyslec zmiane metody
    title = params[:title].titleize
    # full text search -> jest jakims gem do bardziej zaawansowanych postgresowych (pg_search)
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

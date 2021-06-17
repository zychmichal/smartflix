class MoviesController < ApplicationController

  def show

    title = params[:title].humanize.titleize
    movie = Movie.find_by("title like ?", "%#{title}%")

    if movie
      render json: movie
    else
      CreateMovieWorker.perform_async(title)
      render json: {:error => "Sorry not found this title, but try again in few minutes"}.to_json,
             status: 404
    end
  end

  private



end

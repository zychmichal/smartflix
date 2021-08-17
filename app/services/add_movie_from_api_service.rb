# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class AddMovieFromApiService
  def initialize(movie_adapter = Movies::Omdb::Client.new)
    @movie_adapter = movie_adapter
  end

  def add_movie_by_title_and_year(title, year = nil)
    begin
      movie = @movie_adapter.find_by(title: title, year: year)
    rescue Movies::MovieNotFoundError
      Rails.logger.warn("Cannot find movie with title: #{title} and year: #{year.nil? ? 'without year' : year}")
    end

    create_movie(movie) unless movie.nil?
  end

  def add_movies_by_title_and_year(title, year = nil)
    movies = @movie_adapter.search_by_title_and_year(title, year)
    movies.each { |movie| add_movie_by_title_and_year(movie.title, movie.year) }
  rescue Movies::MovieNotFoundError
    Rails.logger.warn("Cannot find movie with title: #{title} and year: #{year.nil? ? 'without year' : year}")
  end

  private

  def create_movie(movie)
    Movie.create!(movie.to_h)
  end
end

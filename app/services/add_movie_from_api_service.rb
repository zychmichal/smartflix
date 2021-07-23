require 'net/http'
require 'uri'
require 'json'
require_relative '../adapters/movie_adapter/omdb_api/omdb'

class AddMovieFromApiService

  def initialize(movie_adapter = Omdb.new)
    @movie_adapter = movie_adapter
  end

  def add_movie_by_title_and_year(title, year = nil)
    movie = @movie_adapter.find_by_title_and_year(title,year)

    create_movie(movie) unless movie.nil?
  end

  def add_movies_by_title_and_year(title, year = nil)
    movies = @movie_adapter.search_by_title_and_year(title,year)

    movies.each { |movie| add_movie_by_title_and_year(movie.title, movie.year) } unless movies.nil?
  end

  private

  def create_movie(movie)
    Movie.create!(movie.to_h)
  end

end

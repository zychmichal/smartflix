# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative '../adapters/omdb'

class AddMovieFromApiService
  def initialize(movie_adapter = Omdb::Client.new)
    @movie_adapter = movie_adapter
  end

  def add_movie_by_title_and_year(title, year = nil)
    movie = @movie_adapter.find_by(title: title, year: year)

    create_movie(movie) unless movie.nil?
  end

  def add_movies_by_title_and_year(title, year = nil)
    movies = @movie_adapter.search_by_title_and_year(title, year)

    # INFO: safe navigator operator -> https://mitrev.net/ruby/2015/11/13/the-operator-in-ruby/
    movies&.each { |movie| add_movie_by_title_and_year(movie.title, movie.year) }
  end

  private

  def create_movie(movie)
    Movie.create!(movie.to_h)
  end
end

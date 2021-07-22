require 'net/http'
require 'uri'
require 'json'

class AddMovieFromApiService

  #OMDBAPI_KEY =  Rails.application.credentials.omdbapi[:key]
  BASE_URI = 'https://www.omdbapi.com/?'
  ERROR_MESSAGE = "Movie not found!"

  def add_movie_by_title_and_year(title, year = nil)
    request_uri = build_uri_by_title(title, year)
    res = Net::HTTP.get_response(request_uri)
    create_movie(res) if res.is_a?(Net::HTTPSuccess)
  end

  def add_movies_by_title_and_year(title, year = nil)
    request_uri = build_uri_by_search(title, year)
    res = Net::HTTP.get_response(request_uri)
    add_movies_from_first_page_response(res) if res.is_a?(Net::HTTPSuccess)
  end

  private

  def add_movies_from_first_page_response(response)
    data = JSON.parse(response.body)
    if data['Response'] == 'True'
      data['Search'].each { |movie| add_movie_by_title_and_year(movie['Title'], movie['Year']) }
    end
  end

  def build_uri_by_search(title, year = nil)
    year.nil? ? build_uri(apikey: Rails.application.credentials.omdbapi[:key], s: title) : build_uri(apikey: Rails.application.credentials.omdbapi[:key], s: title, y: year)
  end

  def build_uri_by_title(title, year = nil)
    year.nil? ? build_uri(apikey: Rails.application.credentials.omdbapi[:key], t: title) : build_uri(apikey: Rails.application.credentials.omdbapi[:key], t: title, y: year)
  end

  def build_uri(params)
    uri = URI(BASE_URI)
    uri.query = URI.encode_www_form(params)
    uri
  end

  def create_movie(response)
    data = JSON.parse(response.body).transform_keys!{|key| key.underscore.to_sym }
    if data[:response] == 'True'
      build_movie_and_add_to_database(data.except(:response))
    end
  end

  def build_movie_and_add_to_database(response_json)
    movie = Movie.new(response_json.except(:type))
    movie.movie_type = response_json[:type]
    movie.title = movie.title.titleize
    movie.save!
  end

end

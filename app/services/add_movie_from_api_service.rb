require 'net/http'
require 'uri'
require 'json'

class AddMovieFromApiService

  OMDBAPI_KEY =  Rails.application.credentials.omdbapi[:key]
  BASE_URI = 'http://www.omdbapi.com/?'
  ERROR_MESSAGE = "Movie not found!"

  def add_movie_by_title_and_year(title, year = nil)
    request_uri = build_uri_by_title(title, year)
    res = Net::HTTP.get_response(request_uri)
    create_movie(res) if res.is_a?(Net::HTTPSuccess)
  end

  def add_movies_by_title_and_year(title, year = nil)
    request_uri = build_uri_by_search(title, year)
    res = Net::HTTP.get_response(request_uri)
    create_movies_from_first_page_response(res) if res.is_a?(Net::HTTPSuccess)
  end

  private

  def create_movies_from_first_page_response(response)
    counter = 0
    data = JSON.parse(response.body)
    if data['Response'] == 'True'
      data['Search'].each { |movie_json| build_movie_and_add_to_database(movie_json.except(:response)); counter += 1 }
      return p "Succesfully create #{counter} movies"
    end
    p ERROR_MESSAGE
  end

  def build_uri_by_search(title, year = nil)
    year.nil? ? build_uri(apikey: OMDBAPI_KEY, s: title) : build_uri(apikey: OMDBAPI_KEY, s: title, y: year)
  end

  def build_uri_by_title(title, year = nil)
    year.nil? ? build_uri(apikey: OMDBAPI_KEY, t: title) : build_uri(apikey: OMDBAPI_KEY, t: title, y: year)
  end

  def build_uri(**kwargs)
    uri = URI("https://www.omdbapi.com/?")
    uri.query = URI.encode_www_form(kwargs)
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

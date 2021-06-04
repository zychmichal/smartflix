require 'net/http'
require 'uri'
require 'json'


class CreateMovieIfExistWorker
  include Sidekiq::Worker
  OMDBAPI_KEY =  Rails.application.credentials.omdbapi[:key]
  BASE_URI = 'http://www.omdbapi.com/?'

  def perform(title)
    request_uri = build_uri(title)
    res = Net::HTTP.get_response(request_uri)
    create_if_success(res) if res.is_a?(Net::HTTPSuccess)
  end

  private
  def build_uri(title)
    params = { :apikey => OMDBAPI_KEY, :t => title }
    uri = URI("https://www.omdbapi.com/?")
    uri.query = URI.encode_www_form(params)
    uri
  end

  def create_if_success(response)
    data = JSON.parse(response.body)
    if data['Response'] == 'True'
      Movie.create(title: data['Title'])
    end
  end
end

# frozen_string_literal: true

# require_relative 'requests/find_movie_request'
# require_relative 'requests/search_movie_request'
# require_relative 'response_builder'

module Omdb
  class Client
    def initialize
      @find_movie_request = Omdb::Requests::FindMovieRequest.new
      @search_movie_request = Omdb::Requests::SearchMovieRequest.new
      @response_builder = Omdb::ResponseBuilder.new
    end

    def find_by(title:, year:)
      response = find_movie_request.find_movie_by_title_and_year(title, year)
      result = nil
      begin
        result = response_builder.build_movie_from_response(response) unless response.nil?
      rescue Omdb::MovieNotFoundError
        Rails.logger.warn("Cannot find movie with title: #{title} and year: #{year.nil? ? 'without year' : year}")
      end
      result
    end

    def search_by_title_and_year(title, year)
      response = search_movie_request.search_movies_by_title_and_year(title, year)
      result = nil
      begin
        result = response_builder.build_movie_search_result_from_response(response) unless response.nil?
      rescue MovieNotFoundError
        Rails.logger.warn("Cannot find movie with title: #{title} and year: #{year.nil? ? 'without year' : year}")
      end
      result
    end

    private

    attr_reader :find_movie_request, :search_movie_request, :response_builder
  end
end

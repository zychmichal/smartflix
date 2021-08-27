# frozen_string_literal: true

module Movies
  module Omdb
    class Client
      def initialize
        @response_builder = Movies::Omdb::ResponseBuilder.new
      end

      def find_by(title:, year:)
        response = Requests::FindMovieRequest.new.find_movie_by_title_and_year(title, year)
        response_builder.build_movie_from_response(response) unless response.nil?
      end

      def search_by(title:, year:)
        response = Requests::SearchMovieRequest.new.search_movies_by_title_and_year(title, year)
        response_builder.build_movie_search_result_from_response(response) unless response.nil?
      end

      private

      attr_reader :response_builder
    end
  end
end

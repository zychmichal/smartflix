# frozen_string_literal: true

require_relative 'response_structs'

module Omdb
  class ResponseBuilder
    def build_movie_from_response(response)
      data = JSON.parse(response.body)
      raise Omdb::MovieNotFoundError unless data['Response'] == 'True'

      prepared_data = prepare_data_from_response(data)
      Omdb::ResponseStructs::MovieStruct.new(prepared_data)
    end

    def build_movie_search_result_from_response(response)
      data = JSON.parse(response.body)
      raise Omdb::MovieNotFoundError if data['Response'] == 'False'

      data['Search'].map do |movie|
        Omdb::ResponseStructs::MovieSearchResult.new(movie['Title'], movie['Year'])
      end
    end

    private

    def prepare_data_from_response(data)
      data.transform_keys! { |key| key.underscore.to_sym }
      data[:movie_type] = data.delete(:type)
      data[:title] = data[:title].titleize
      data.except(:response)
    end
  end
end

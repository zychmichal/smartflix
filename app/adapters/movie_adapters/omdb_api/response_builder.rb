require_relative 'response_structs'
require_relative 'movie_not_found_error'

class ResponseBuilder

  def build_movie_from_response(response)
    data = JSON.parse(response.body)
    raise MovieNotFoundError unless data['Response'] == 'True'

    prepared_data = prepare_data_from_response(data)
    build_movie(prepared_data)
  end

  def build_movie_search_result_from_response(response)
    data = JSON.parse(response.body)
    movies_search_result = []
    raise MovieNotFoundError unless data['Response'] == 'True'

    data['Search'].each { |movie| movies_search_result << MovieSearchResult.new(movie['Title'], movie['Year']) }
    movies_search_result
  end

  private

  def build_movie(response_hash)
    MovieStruct.new(response_hash)
  end

  def prepare_data_from_response(data)
    data.transform_keys!{|key| key.underscore.to_sym }
    data[:movie_type] = data.delete(:type)
    data[:title] = data[:title].titleize
    data.except(:response)
  end

end

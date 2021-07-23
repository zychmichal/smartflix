require_relative 'uri_omdb_builder'

class SearchMovieRequest

  include UriOmdbBuilder

  def search_movies_by_title_and_year(title, year = nil)
    request_uri = build_uri_by_search(title, year)
    res = Net::HTTP.get_response(request_uri)
    res if res.is_a?(Net::HTTPSuccess)
  end

  private

  def build_uri_by_search(title, year = nil)
    year.nil? ? build_uri(s: title) : build_uri(s: title, y: year)
  end

end

module UriOmdbBuilder
  BASE_URI = 'https://www.omdbapi.com/?'

  def build_uri(params)
    params = {apikey: Rails.application.credentials.omdbapi[:key]}.merge(params)
    uri = URI(BASE_URI)
    uri.query = URI.encode_www_form(params)
    uri
  end

end

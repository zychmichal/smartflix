class DeleteMoviesService

  def delete_outdated_movies
    Movie.find_each { |movie| movie.delete if not_updated_since_two_days?(movie) }
  end

  private

  def not_updated_since_two_days?(movie)
    ((Time.zone.now - movie.updated_at) / 1.day) > 2
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateMoviesWorker, type: :worker do
  subject(:update_movies_worker) { described_class.new.perform }

  let(:movies) { [Movie.new(title: 'Troy', id: 1), Movie.new(title: 'Godfather', id: 2)]}
  before do
    allow(Movie).to receive(:find_each).and_yield(movies[0]).and_yield(movies[1])
  end

  it 'calls UpdateSingleMovieWorker for each movie' do
    movies.each{ |movie| expect(UpdateSingleMovieWorker).to receive(:perform_async).with(movie.id)}
    update_movies_worker
  end
end

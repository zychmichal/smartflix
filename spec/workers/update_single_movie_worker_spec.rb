# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateSingleMovieWorker, type: :worker do
  subject(:update_single_movie_worker) { described_class.new.perform(movie_id) }
  let(:service) { UpdateMovieFromApiService.new }

  let(:movie_id) { 1 }
  let(:movie) { Movie.new(title: 'Troy', id: movie_id)}
  before do
    allow(Movie).to receive(:find_by).with(id: movie_id).and_return(movie)
    allow(UpdateMovieFromApiService).to receive(:new).and_return(service)
  end

  it 'calls UpdateSingleMovieService for proper' do
    expect(service).to receive(:update_movie).with(movie)
    update_single_movie_worker
  end
end

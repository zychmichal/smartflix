# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateMovieWorker, type: :worker do
  subject(:create_movie_worker) { described_class.new.perform(title) }

  let(:api_service) { instance_double('AddMovieFromApiService') }
  let(:title) { 'Troy' }

  before { allow(AddMovieFromApiService).to receive(:new).and_return(api_service) }

  it 'calls api service with proper title' do
    expect(api_service).to receive(:add_movie_by_title_and_year).with(title)
    create_movie_worker
  end
end

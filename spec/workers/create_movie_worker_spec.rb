# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateMovieWorker, type: :worker do
  subject(:create_movie_worker) { described_class.new.perform(title) }

  let(:api) { AddMovieFromApiService.new }
  let(:title) { 'Troy' }

  before { allow(AddMovieFromApiService).to receive(:new).and_return(api) }

  it 'calls api with proper title' do
    expect(api).to receive(:add_movie_by_title_and_year).with(title)
    create_movie_worker
  end
end

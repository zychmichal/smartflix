require 'rails_helper'

RSpec.describe CreateMovieWorker, type: :worker do
  subject { worker.perform(title) }

  let(:worker) { described_class.new }
  let(:api) { AddMovieFromApiService.new }
  let(:title) {"Troy"}

  before { allow(AddMovieFromApiService).to receive(:new).and_return(api) }

  it 'should call api with title' do
    expect(api).to receive(:add_movie_by_title_and_year).with(title)
    subject
  end

end

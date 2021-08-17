# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateMovieFromApiService do
  #  TODO change this specs -> use frozen timezone
  subject(:update_movie_from_api_service) { described_class.new(adapter) }

  let(:title) { 'Troy' }
  let(:year) { 2010 }
  let(:adapter) { instance_double(Movies::Omdb::Client) }
  let(:updated_at) { Date.new(2020, 10, 10) }
  let(:movie) { Movie.new(title: title, year: year, updated_at: updated_at) }

  before do
    movie.save!
  end

  describe '#update_movie' do
    context 'when adapter return a movie struct' do
      before do
        allow(adapter).to receive(:find_by).with(title: movie.title, year: movie.year).and_return(update_movie_struct)
      end

      context 'when new attributes are different than previous' do
        let(:updated_year) { 2011 }
        let(:updated_title) { 'new title' }
        let(:update_movie_struct) do
          Movies::Omdb::ResponseStructs::MovieStruct.new(title: updated_title, year: updated_year)
        end

        it 'updates movie and changes updated_at field ' do
          update_movie_from_api_service.update_movie(movie)
          expect(Movie.first.updated_at).not_to eq(updated_at)
          expect(Movie.first.title).to eq(updated_title)
          expect(Movie.first.year).to eq(updated_year)
        end
      end

      context 'when new attributes are the same' do
        let(:update_movie_struct) { Movies::Omdb::ResponseStructs::MovieStruct.new(title: title, year: year) }

        it 'changes updated_at field ' do
          update_movie_from_api_service.update_movie(movie)
          expect(Movie.first.updated_at).not_to eq(updated_at)
        end
      end
    end

    context 'when adapter not find title' do
      let(:warn_message) { "Cannot find movie with title: #{movie.title} and year: #{movie.year}" }

      before do
        allow(adapter).to receive(:find_by).with(title: movie.title,
                                                 year: movie.year).and_raise(Movies::MovieNotFoundError)
      end

      it 'does not change update at date' do
        expect(Rails.logger).to receive(:warn).with(warn_message)

        update_movie_from_api_service.update_movie(movie)
        expect(Movie.first.updated_at).to eq(updated_at)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteMoviesService do
  subject(:delete_movies_service) { described_class.new }

  let(:first_movie) { Movie.new(title: 'Troy', updated_at: 2.days.ago - 1.minute, id: 1) }
  let(:second_movie) { Movie.new(title: 'Godfather', id: 2, updated_at: Time.zone.now) }

  describe '#delete_outdated_movies' do
    before do
      first_movie.save!
      second_movie.save!
    end

    context 'when exist movie which has not updated since more than 2 day' do
      it 'deletes this movie from database' do
        expect { delete_movies_service.delete_outdated_movies }.to change(Movie, :count).from(2).to(1)
        expect(Movie.all).not_to include(first_movie)
        expect(Movie.all).to include(second_movie)
      end
    end

    context 'when all movies have updated since less than 2 days' do
      let(:first_movie) { Movie.new(title: 'Troy', updated_at: 2.days.ago + 1.minute, id: 1) }

      it 'deletes this movie from database' do
        expect { delete_movies_service.delete_outdated_movies }.not_to change(Movie, :count)
        expect(Movie.all).to include(first_movie)
        expect(Movie.all).to include(second_movie)
      end
    end
  end
end

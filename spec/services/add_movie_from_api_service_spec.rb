# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddMovieFromApiService do
  subject(:add_movie_service) { described_class.new }

  let(:title) { 'Harry Potter' }

  context 'when adds single movie' do
    context 'when OMDB API find movie with only title' do
      it 'creates movie without year in request' do
        VCR.use_cassette('omdbapi_title') do
          expect { add_movie_service.add_movie_by_title_and_year(title) }.to change(Movie, :count).from(0).to(1)
          expect(Movie.first.title).to eq('Harry Potter And The Deathly Hallows: Part 2')
        end
      end
    end

    context 'when API not found title' do
      let(:title) { 'not existing movie' }

      it "doesn't create movie when movie title doesn't found in omdbapi" do
        VCR.use_cassette('omdbapi_not_exist_title') do
          expect { add_movie_service.add_movie_by_title_and_year(title) }.to change(Movie, :count).by(0)
        end
      end
    end

    context 'when add single movie from OMDB API with year' do
      let(:year) { 2010 }

      it 'adds movie to database with year in request if response is success' do
        VCR.use_cassette('omdbapi_title_with_year') do
          expect { add_movie_service.add_movie_by_title_and_year(title, year) }.to change(Movie, :count).from(0).to(1)
          expect(Movie.first.title).to eq('Harry Potter And The Deathly Hallows: Part 1')
        end
      end
    end
  end

  context 'when use searching more movies in OMDB API' do
    context 'when API find title' do
      let(:title) { 'Harry' }

      it 'creates movie from first page of response' do
        VCR.use_cassette('omdbapi_response_for_more_movies') do
          expect { add_movie_service.add_movies_by_title_and_year(title) }.to change(Movie, :count).from(0).to(10)
          Movie.all.each { |movie| expect(movie.title).to match(title) }
        end
      end
    end

    context 'when OMDB API finds movie with title and year' do
      let(:year) { 2015 }

      it 'adds movie to database with year in request if response is success' do
        VCR.use_cassette('omdbapi_response_for_more_movie_with_year') do
          expect { add_movie_service.add_movies_by_title_and_year(title, year) }.to change(Movie, :count).from(0).to(3)
          Movie.all.each { |movie| expect(movie.title).to match(title) }
        end
      end
    end

    context "when API doesn't find title" do
      let(:title) { 'not existing movie' }

      it "doesn't create movie when movie title doesn't find in omdbapi" do
        VCR.use_cassette('omdbapi_not_exist_title_for_more_movies') do
          expect { add_movie_service.add_movies_by_title_and_year(title) }.to change(Movie, :count).by(0)
        end
      end
    end
  end
end

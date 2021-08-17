# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movies::Omdb::Client do
  subject(:omdb_client) { described_class.new }

  let(:title) { 'Harry Potter' }
  let(:movie) do
    Movies::Omdb::ResponseStructs::MovieStruct.new(title: 'Harry Potter And The Deathly Hallows: Part 2', year: '2011')
  end

  context 'when adds single movie' do
    context 'when OMDB API find movie with only title' do
      it 'creates movie without year in request' do
        VCR.use_cassette('omdbapi_title') do
          result = omdb_client.find_by(title: title, year: nil)

          expect(result.title).to eq(movie.title)
          expect(result.year).to eq(movie.year)
        end
      end
    end

    context 'when API not found title' do
      let(:title) { 'not existing movie' }

      it "doesn't create movie when movie title doesn't found in omdbapi" do
        VCR.use_cassette('omdbapi_not_exist_title') do
          expect { omdb_client.find_by(title: title, year: nil) }.to raise_error(Movies::MovieNotFoundError)
        end
      end
    end

    context 'when add single movie from OMDB API with year' do
      let(:year) { 2010 }
      let(:movie) do
        Movies::Omdb::ResponseStructs::MovieStruct.new(title: 'Harry Potter And The Deathly Hallows: Part 1',
                                                       year: '2010')
      end

      it 'adds movie to database with year in request if response is success' do
        VCR.use_cassette('omdbapi_title_with_year') do
          result = omdb_client.find_by(title: title, year: year)

          expect(result.title).to eq(movie.title)
          expect(result.year).to eq(movie.year)
        end
      end
    end
  end

  context 'when use searching more movies in OMDB API' do
    context 'when API find title' do
      let(:title) { 'Harry' }

      it 'creates movie from first page of response' do
        VCR.use_cassette('omdbapi_response_for_more_movies') do
          result = omdb_client.search_by_title_and_year(title, nil)

          expect(result.count).to eq(10)
          result.each { |movie| expect(movie.title).to match(title) }
        end
      end
    end

    context 'when OMDB API finds movies with title and year' do
      let(:year) { 2015 }

      it 'with year in request if response is success' do
        VCR.use_cassette('omdbapi_response_for_more_movie_with_year') do
          result = omdb_client.search_by_title_and_year(title, year)

          expect(result.count).to eq(3)
          result.each { |movie| expect(movie.title).to match(title) }
        end
      end
    end

    context "when API doesn't find title" do
      let(:title) { 'not existing movie' }

      it "doesn't create movie when movie title doesn't find in omdbapi" do
        VCR.use_cassette('omdbapi_not_exist_title_for_more_movies') do
          expect { omdb_client.search_by_title_and_year(title, nil) }.to raise_error(Movies::MovieNotFoundError)
        end
      end
    end
  end
end

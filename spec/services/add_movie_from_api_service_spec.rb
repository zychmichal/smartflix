# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddMovieFromApiService do
  subject(:add_movie_service) { described_class.new(adapter) }

  let(:adapter) { instance_double(Movies::Omdb::Client) }
  let(:title) { 'Harry Potter' }
  let(:year) { nil }

  describe '#add_movie_by_title_and_year' do
    let(:result_movie_struct) { Movies::Omdb::ResponseStructs::MovieStruct.new(title: title, year: year) }

    before { allow(adapter).to receive(:find_by).with(title: title, year: year).and_return(result_movie_struct) }

    context 'when only title is added' do
      it 'creates movie' do
        expect(adapter).to receive(:find_by).with(title: title, year: year).and_return(result_movie_struct)

        expect { add_movie_service.add_movie_by_title_and_year(title) }.to change(Movie, :count).from(0).to(1)
        expect(Movie.first.title).to eq('Harry Potter')
      end
    end

    context 'when title and year is added' do
      let(:year) { 2010 }

      it 'creates movie' do
        expect(adapter).to receive(:find_by).with(title: title, year: year).and_return(result_movie_struct)

        expect { add_movie_service.add_movie_by_title_and_year(title, year) }.to change(Movie, :count).from(0).to(1)
        expect(Movie.first.title).to eq('Harry Potter')
        expect(Movie.first.year).to eq(year)
      end
    end

    context 'when adapter not send movie' do
      let(:result_movie_struct) { nil }

      it 'does not add movie to database' do
        expect(adapter).to receive(:find_by).with(title: title, year: year).and_return(result_movie_struct)

        expect { add_movie_service.add_movie_by_title_and_year(title) }.not_to change(Movie, :count)
      end
    end
  end

  # rubocop:disable RSpec/SubjectStub
  describe '#add_movies_by_title_and_year' do
    let(:another_title) { 'HP' }
    let(:movie_search_results) do
      [Movies::Omdb::ResponseStructs::MovieSearchResult.new(title, year),
       Movies::Omdb::ResponseStructs::MovieSearchResult.new(another_title, year)]
    end

    before do
      # zbedne allow
      allow(adapter).to receive(:search_by_title_and_year).with(title, year).and_return(movie_search_results)
      allow(add_movie_service).to receive(:add_movie_by_title_and_year)
    end

    context 'when API find movies' do
      context 'when year is not provided' do
        it 'creates movie from first page of response' do
          expect(adapter).to receive(:search_by_title_and_year).with(title, year).and_return(movie_search_results)
          expect(add_movie_service).to receive(:add_movie_by_title_and_year).with(title, year).ordered
          expect(add_movie_service).to receive(:add_movie_by_title_and_year).with(another_title, year).ordered

          add_movie_service.add_movies_by_title_and_year(title)
        end
      end

      context 'when year is also provided' do
        let(:year) { 2010 }

        it 'creates movie from first page of response' do
          expect(adapter).to receive(:search_by_title_and_year).with(title, year).and_return(movie_search_results)
          expect(add_movie_service).to receive(:add_movie_by_title_and_year).with(title, year).ordered
          expect(add_movie_service).to receive(:add_movie_by_title_and_year).with(another_title, year).ordered

          add_movie_service.add_movies_by_title_and_year(title, year)
        end
      end
    end

    context 'when API not found title' do
      let(:title) { 'not existing movie' }

      let(:warn_message) { 'Cannot find movie with title: not existing movie and year: without year' }

      it 'does not call add_movie_by_title_and_year' do
        expect(adapter).to receive(:search_by_title_and_year).with(title, year).and_raise(Movies::MovieNotFoundError)
        expect(add_movie_service).not_to receive(:add_movie_by_title_and_year)
        expect(Rails.logger).to receive(:warn).with(warn_message)

        add_movie_service.add_movies_by_title_and_year(title)
      end
    end
  end
  # rubocop:enable RSpec/SubjectStub
end

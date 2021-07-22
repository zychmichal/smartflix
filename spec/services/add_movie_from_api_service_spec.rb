require 'rails_helper'

RSpec.describe AddMovieFromApiService do
  subject { described_class.new }

  let(:title) {"Harry Potter"}
  before { Rails.application.credentials.omdbapi[:key] = "apikey" }

  context "add single movie" do
    context "add single movie from OMDB API without year" do
      it "creates movie without year in request" do
        VCR.use_cassette("omdbapi_title") do
          expect{ subject.add_movie_by_title_and_year(title) }.to change{Movie.count}.from(0).to(1)
          expect(Movie.first.title).to eq("Harry Potter And The Deathly Hallows: Part 2")
        end
      end
    end

    context "add single movie from OMDB API when API not found title" do
      let(:title) {"not existing movie"}
      it "doesn't create movie when movie title doesn't found in omdbapi" do
        VCR.use_cassette("omdbapi_not_exist_title") do
          expect{ subject.add_movie_by_title_and_year(title) }.to change{Movie.count}.by(0)
        end
      end
    end

    context "add single movie from OMDB API with year" do
      let(:year) { 2010 }
      it "adds movie to database with year in request if response is success" do
        VCR.use_cassette("omdbapi_title_with_year") do
          expect { subject.add_movie_by_title_and_year(title, year) }.to change{Movie.count}.from(0).to(1)
          expect(Movie.first.title).to eq("Harry Potter And The Deathly Hallows: Part 1")
        end
      end
    end
  end

  context "add more movies in one request (s params in query)" do
    context "add movies from OMDB API when API found title" do
      let(:title) {"Harry"}
      it "creates movie from first page of response" do
        VCR.use_cassette("omdbapi_response_for_more_movies") do
          expect{ subject.add_movies_by_title_and_year(title) }.to change{Movie.count}.from(0).to(10)
          Movie.all.each do |movie|
            expect(movie.title).to match(title)
          end
        end
      end
    end

    context "add movies from OMDB API with year" do
      let(:year) { 2015 }
      it "adds movie to database with year in request if response is success" do
        VCR.use_cassette("omdbapi_response_for_more_movie_with_year") do
          expect{ subject.add_movies_by_title_and_year(title, year) }.to change{Movie.count}.from(0).to(3)
          Movie.all.each do |movie|
            expect(movie.title).to match(title)
          end
        end
      end
    end

    context "add movies from OMDB API when API not found title" do
      let(:title) {"not existing movie"}
      it "doesn't create movie when movie title doesn't found in omdbapi" do
        VCR.use_cassette("omdbapi_not_exist_title_for_more_movies") do
          expect{ subject.add_movies_by_title_and_year(title) }.to change{Movie.count}.by(0)
        end
      end
    end
  end

end


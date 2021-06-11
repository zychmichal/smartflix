require 'rails_helper'

RSpec.describe AddMovieFromApiService do
  OMDBAPI_KEY = Rails.application.credentials.omdbapi[:key]
  subject { described_class.new }
  base_url = "https://www.omdbapi.com/?apikey=#{OMDBAPI_KEY}"
  let(:actual_url) { base_url + params }

  context "Adding single movie" do
    context "adding single movie from OMDB API without year" do
      let(:params) {"&t=Harry"}
      let(:json_response) { File.open("spec/fixtures/json/title_harry_without_year.json") }
      it "create movie without year in request" do
        stub_request(:get, actual_url).to_return(status: 200, body: json_response)
        expect {subject.add_movie_by_title("Harry")}.to change{Movie.count}.from(0).to(1)
        expect(Movie.first.title).to eq("Harry Potter and the Deathly Hallows: Part 2")
      end
    end

    context "adding single movie from OMDB API when API not found title" do
      let(:params) {"&t=not_existing_movie"}
      let(:json_response) { File.open("spec/fixtures/json/movie_not_found_response.json") }
      it "doesn't create movie when movie title doesn't found in omdbapi" do
        stub_request(:get, actual_url).to_return(status: 200, body: json_response)
        expect{subject.add_movie_by_title("not_existing_movie")}.to change{Movie.count}.by(0)
      end
    end

    context "adding single movie from OMDB API with year" do
      let(:params) {"&t=Harry&y=2010"}
      let(:json_response) { File.open("spec/fixtures/json/title_harry_year_2010.json") }
      it "add movie to database with year in request if response is success" do
        stub_request(:get, actual_url).to_return(status: 200, body: json_response)
        expect {subject.add_movie_by_title("Harry", 2010)}.to change{Movie.count}.from(0).to(1)
        expect(Movie.first.title).to eq("Harry Potter and the Deathly Hallows: Part 1")
      end
    end
  end
end


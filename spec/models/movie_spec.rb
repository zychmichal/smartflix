require 'rails_helper'

# based on: https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec, and api

RSpec.describe Movie, type: :model do

  subject { described_class.new(title: title) }
  let(:title) { "Troy" }

  describe "presence" do
    context "title is presence" do
      it "is valid with valid attributes" do
        expect(subject).to be_valid
      end

    end

    context "title isn't presence" do
      let(:title) { nil }
      it "is not valid without a title" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe "uniqueness" do
    context "movie with same title is add only one" do
      it "is valid with valid attributes" do
        expect(subject).to be_valid
      end

    end

    context "movie with same title is add more than one" do
      before { Movie.create!(title: title )}
      it "is not valid because of not uniqueness titles" do
        expect(subject).to_not be_valid
      end
    end
  end



end

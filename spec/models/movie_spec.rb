require 'rails_helper'

# based on: https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec, and api

RSpec.describe Movie, type: :model do

  subject { Movie.new(title: title) }
  let(:title) { "Troy" }

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

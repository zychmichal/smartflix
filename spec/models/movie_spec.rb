# frozen_string_literal: true

require 'rails_helper'

# based on: https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec, and api

RSpec.describe Movie, type: :model do
  subject(:movie) { described_class.new(title: title) }

  let(:title) { 'Troy' }

  describe 'presence' do
    context 'when title is presence' do
      it 'is valid with valid attributes' do
        expect(movie).to be_valid
      end
    end

    context "when title isn't presence" do
      let(:title) { nil }

      it 'is not valid without a title' do
        expect(movie).not_to be_valid
      end
    end
  end

  describe 'uniqueness' do
    context 'when movie with same title is add only one' do
      it 'is valid with valid attributes' do
        expect(movie).to be_valid
      end
    end

    context 'when movie with same title is add more than one' do
      before { described_class.create!(title: title) }

      it 'is not valid because of not uniqueness titles' do
        expect(movie).not_to be_valid
      end
    end
  end
end

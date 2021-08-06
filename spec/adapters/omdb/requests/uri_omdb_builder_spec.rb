# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Omdb::Requests::UriOmdbBuilder do
  let(:object) { Object.new }

  before do
    object.extend(described_class)
  end

  context 'when params hash is not empty ' do
    it 'adds all params to base url with api key' do
      params = { param1: 'value1', param2: 'value2' }

      expect(object.build_uri(params).to_s).to eq('https://www.omdbapi.com/?apikey=apikey&param1=value1&param2=value2')
    end
  end
end

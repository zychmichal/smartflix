# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteMoviesWorker, type: :worker do
  subject(:delete_movies_worker) { described_class.new.perform }
  let(:service) { DeleteMoviesService.new }

  before { allow(DeleteMoviesService).to receive(:new).and_return(service)}
  it 'calls delete service' do
    expect(service).to receive(:delete_outdated_movies).with(no_args)
    delete_movies_worker
  end

end

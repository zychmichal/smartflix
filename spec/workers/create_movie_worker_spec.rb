require 'rails_helper'

RSpec.describe CreateMovieWorker, type: :worker do
  subject { worker.perform }

  let(:worker) { described_class.new }

  it 'should add Movie to database' do
    expect {subject}.to change{Movie.count}.from(0).to(1)
  end

end

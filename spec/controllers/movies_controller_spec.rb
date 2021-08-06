# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:title) { 'Troy' }
  let(:movie) { Movie.new(title: title) }

  describe 'GET #show' do
    before { allow(Movie).to receive(:find_by).with('title like ?', "%#{title}%").and_return(movie) }

    context 'when movie is in database' do
      it 'renders all movie which movie title is like title parameter ' do
        get(:show, params: { title: title })

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(movie.title)
      end
    end

    context 'when movie is not in database' do
      let(:movie) { nil }

      before { allow(Movie).to receive(:find_by).with('title like ?', "%#{title}%").and_return(movie) }

      it 'renders error message and call create movie worker ' do
        get(:show, params: { title: title })

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Sorry not found this title, but try again in few minutes')
      end
    end
  end
end

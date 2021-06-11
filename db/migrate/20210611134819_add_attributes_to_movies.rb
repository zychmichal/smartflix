class AddAttributesToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :year, :integer
    add_column :movies, :rated, :string
    add_column :movies, :released, :date
    add_column :movies, :runtime, :integer
    add_column :movies, :genre, :string
    add_column :movies, :director, :string
    add_column :movies, :writer, :string
    add_column :movies, :actors, :string
    add_column :movies, :plot, :text
    add_column :movies, :language, :string
    add_column :movies, :country, :string
    add_column :movies, :awards, :string
    add_column :movies, :poster, :string
    add_column :movies, :ratings, :text
    add_column :movies, :metascore, :integer
    add_column :movies, :imdb_rating, :float
    add_column :movies, :imdb_votes, :bigint
    add_column :movies, :imdb_id, :string
    add_column :movies, :movie_type, :string
    add_column :movies, :dvd, :date
    add_column :movies, :box_office, :string
    add_column :movies, :production, :string
    add_column :movies, :website, :string

    add_index :movies, :title
  end
end

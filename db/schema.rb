# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_11_134819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "year"
    t.string "rated"
    t.date "released"
    t.integer "runtime"
    t.string "genre"
    t.string "director"
    t.string "writer"
    t.string "actors"
    t.text "plot"
    t.string "language"
    t.string "country"
    t.string "awards"
    t.string "poster"
    t.text "ratings"
    t.integer "metascore"
    t.float "imdb_rating"
    t.bigint "imdb_votes"
    t.string "imdb_id"
    t.string "movie_type"
    t.date "dvd"
    t.string "box_office"
    t.string "production"
    t.string "website"
    t.index ["title"], name: "index_movies_on_title"
  end

end

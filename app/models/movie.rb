class Movie < ApplicationRecord
    validates :title, uniqueness: true, presence: true
end

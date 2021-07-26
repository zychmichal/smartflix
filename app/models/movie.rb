# frozen_string_literal: true

class Movie < ApplicationRecord
  validates :title, uniqueness: true, presence: true
end

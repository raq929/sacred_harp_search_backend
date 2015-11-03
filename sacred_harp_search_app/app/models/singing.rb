class Singing < ActiveRecord::Base
  has_many :calls
  has_many :songs, through: :calls
  has_many :callers, through: :calls
end

class Caller < ActiveRecord::Base
  has_many :calls
  has_many :songs, through: :calls
  has_many :singings, through: :calls
end

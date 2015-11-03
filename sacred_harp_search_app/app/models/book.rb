class Book < ActiveRecord::Base
  has_many :songs
end

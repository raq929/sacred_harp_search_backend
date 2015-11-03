class Song < ActiveRecord::Base
  has_one :book
end

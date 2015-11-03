class Song < ActiveRecord::Base
  has_one :book
  has_many :calls
  has_many :callers, through: :calls
  has_many :singings, through: :calls
end

class Call < ActiveRecord::Base
  belongs_to :callers
  has_many :songs
  has_one :singing
end

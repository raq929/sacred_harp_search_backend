# == Schema Information
#
# Table name: songs
#
#  id         :integer          not null, primary key
#  number     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer
#

class Song < ActiveRecord::Base
  belongs_to :book
  has_many :calls
  has_many :callers, through: :calls
  has_many :singings, through: :calls

  validates :name, presence: true
  validates :book_id, presence: true
end

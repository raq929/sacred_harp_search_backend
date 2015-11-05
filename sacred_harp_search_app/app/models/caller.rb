# == Schema Information
#
# Table name: callers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Caller < ActiveRecord::Base
  has_many :calls
  has_many :songs, through: :calls
  has_many :singings, through: :calls

  validates :name, presence: true
end

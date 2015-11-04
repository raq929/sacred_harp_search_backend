# == Schema Information
#
# Table name: singings
#
#  id         :integer          not null, primary key
#  name       :string
#  city       :string
#  state      :string
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Singing < ActiveRecord::Base
  has_many :calls
  has_many :songs, through: :calls
  has_many :callers, through: :calls
end

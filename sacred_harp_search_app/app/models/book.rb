# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ActiveRecord::Base
  has_many :songs
end

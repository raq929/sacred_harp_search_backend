# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
class BookSerializer < ActiveModel::Serializer
  attributes :id, :name
end

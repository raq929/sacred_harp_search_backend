# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  token           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :current_user

  def current_user
    scope == object
  end
end

# == Schema Information
#
# Table name: calls
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  song_id    :integer
#  caller_id  :integer
#  singing_id :integer
#

class Call < ActiveRecord::Base
  belongs_to :caller
  belongs_to :song
  belongs_to :singing

  validates :song_id, presence: true
  validates :singing_id, presence: true
end

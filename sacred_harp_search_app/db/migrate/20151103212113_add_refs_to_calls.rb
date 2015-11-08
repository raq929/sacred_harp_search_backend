class AddRefsToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :song, index: true, foreign_key: true
    add_reference :calls, :caller, index: true, foreign_key: true
    add_reference :calls, :singing, index: true, foreign_key: true
    add_index :calls, [:song_id, :singing_id], unique: true
  end
end

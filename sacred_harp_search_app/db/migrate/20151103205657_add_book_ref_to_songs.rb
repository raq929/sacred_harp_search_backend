class AddBookRefToSongs < ActiveRecord::Migration
  def change
    add_reference :songs, :book, index: true, foreign_key: true
  end
end

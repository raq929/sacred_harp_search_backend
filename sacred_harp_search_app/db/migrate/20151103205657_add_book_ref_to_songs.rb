class AddBookRefToSongs < ActiveRecord::Migration
  def change
    add_reference :songs, :book, index: true, foreign_key: true
    add_index :songs, [:name, :book_id], unique: true
  end
end

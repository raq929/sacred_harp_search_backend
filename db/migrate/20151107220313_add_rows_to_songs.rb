class AddRowsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :title_ordinal, :string
    add_column :songs, :meter_name, :string
    add_column :songs, :meter_count, :string
    add_column :songs, :song_text, :text
    add_column :songs, :composer_first_name, :string
    add_column :songs, :composer_last_name, :string
    add_column :songs, :composition_date, :string
    add_column :songs, :poet_first_name, :string
    add_column :songs, :poet_last_name, :string

    add_index :songs, [:name, :title_ordinal, :book_id], unique: true
  end
end

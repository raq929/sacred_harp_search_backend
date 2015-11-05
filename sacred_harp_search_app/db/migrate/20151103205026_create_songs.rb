class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :number, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :songs, [:name, :book_id], unique: true
  end
end

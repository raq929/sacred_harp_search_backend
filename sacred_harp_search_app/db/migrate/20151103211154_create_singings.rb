class CreateSingings < ActiveRecord::Migration
  def change
    create_table :singings do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.start_date :date, null: false
      t.end_date :date, null: false

      t.timestamps null: false
    end
  end
  add_index :singings, [:name, :start_date], unique: true
end

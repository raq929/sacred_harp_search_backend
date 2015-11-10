class CreateSingings < ActiveRecord::Migration
  def change
    create_table :singings do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :date, null: false

      t.timestamps null: false
    end
  end
end

class CreateSingings < ActiveRecord::Migration
  def change
    create_table :singings do |t|
      t.string :name
      t.string :city
      t.string :state
      t.date :date

      t.timestamps null: false
    end
  end
end

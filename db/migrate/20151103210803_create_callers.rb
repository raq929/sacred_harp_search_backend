class CreateCallers < ActiveRecord::Migration
  def change
    create_table :callers do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end
  end
end

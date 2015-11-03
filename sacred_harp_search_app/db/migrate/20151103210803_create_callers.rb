class CreateCallers < ActiveRecord::Migration
  def change
    create_table :callers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

class AddIndexToSingings < ActiveRecord::Migration
  def change
    add_index :singings, [:name, :date], unique: true
  end
end

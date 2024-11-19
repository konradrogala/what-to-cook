class AddIndexToIngredientName < ActiveRecord::Migration[7.2]
  add_index :ingredients, :name, algorithm: :concurrently
end

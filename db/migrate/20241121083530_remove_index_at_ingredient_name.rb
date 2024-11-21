class RemoveIndexAtIngredientName < ActiveRecord::Migration[7.2]
  disable_ddl_transaction! # Dla bezpiecznego usuwania indeksu w dużych tabelach

  def change
    remove_index :ingredients, column: :name, algorithm: :concurrently
  end
end

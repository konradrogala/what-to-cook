class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :cook_time
      t.integer :prep_time
      t.integer :rating
      t.string :cuisine
      t.string :image_url
      t.string :author
      t.string :category

      t.timestamps
    end
  end
end

class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true

  scope :by_ingredients, ->(ingredient_ids, min_count) {
    joins(:recipe_ingredients)
      .where(recipe_ingredients: { ingredient_id: ingredient_ids })
      .group("recipes.id")
      .having("COUNT(DISTINCT recipe_ingredients.ingredient_id) >= ?", min_count)
      .includes(:ingredients)
  }
end

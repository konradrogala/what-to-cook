class Recipe < ApplicationRecord
  include PgSearch::Model

  # Zakładamy, że Recipe ma wiele składników przez RecipeIngredient
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  pg_search_scope :search_by_ingredients,
    associated_against: {
      ingredients: :name # Wyszukiwanie w nazwach składników
    },
    using: {
      tsearch: { prefix: true } # Częściowe dopasowanie np. 'gar' znajdzie 'garlic'
    }
end

# frozen_string_literal: true

module IngredientService
  class Creator
    def initialize
      @existing_ingredients = ::Ingredient.pluck(:name, :id).to_h
    end

    def create_for_recipe(recipe, ingredients)
      ingredients_data = ingredients.map { |ingredient| prepare_ingredient_data(recipe, ingredient) }
      ::RecipeIngredient.insert_all(ingredients_data)
    end

    private

    attr_reader :existing_ingredients

    def prepare_ingredient_data(recipe, ingredient)
      ingredient_data = Parser.parse(ingredient)
      ingredient_id = find_or_create_ingredient(ingredient_data[:name])

      {
        recipe_id: recipe.id,
        ingredient_id: ingredient_id,
        amount: ingredient_data[:amount],
        unit: ingredient_data[:unit]
      }
    end

    def find_or_create_ingredient(name)
      existing_ingredients[name] ||= ::Ingredient.create!(name: name).id
    end
  end
end

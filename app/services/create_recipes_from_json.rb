# frozen_string_literal: true

class CreateRecipesFromJson
  def initialize(file_path)
    @file_path = file_path
  end

  def create
    recipes = parse_recipes
    progress = ImportProgress.new(recipes.size)

    Recipe.transaction do
      recipes.each_with_index do |recipe_data, index|
        created_recipe = RecipeService::Creator.create(recipe_data)
        ingredient_creator.create_for_recipe(created_recipe, recipe_data["ingredients"])
        progress.update(index + 1, recipes.size)
      end
    end
  end

  private

  attr_reader :file_path

  def ingredient_creator
    @ingredient_creator ||= IngredientService::Creator.new
  end

  def parse_recipes
    JSON.parse(File.read(file_path))
  rescue JSON::ParserError => e
    raise "Nie udało się sparsować pliku JSON: #{e.message}"
  end
end

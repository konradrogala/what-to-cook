class FindRecipesByIngredients
  def initialize(search_params)
    @search_params = search_params
  end

  def result
    query_without_commas = ingredient_query.gsub(",", "").strip

    if query_without_commas.length < 2
      @recipes = []
    else
      if matching_ingredients.any?
        @recipes = Recipe.joins(:recipe_ingredients)
                         .where(recipe_ingredients: { ingredient_id: matching_ingredients })
                         .group("recipes.id")
                         .having("COUNT(DISTINCT recipe_ingredients.ingredient_id) >= ?", ingredients.size).includes(:ingredients)
      else
        @recipes = []
      end
    end
  end

  private

  attr_reader :search_params

  def ingredient_query
    @ingredient_query ||= search_params.to_s.strip
  end

  def ingredients
    @ingredients ||= ingredient_query.split(",").map(&:strip).reject(&:blank?)
  end

  def matching_ingredients
   ingredients.flat_map do |ingredient|
      Ingredient.search_by_name(ingredient).pluck(:id)
    end
  end
end

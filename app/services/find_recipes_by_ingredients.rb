class FindRecipesByIngredients
  def initialize(search_params)
    @search_params = search_params
  end

  def result
    return [] if query_without_commas.length < 2 || matching_ingredients_ids.empty?

    Recipe.by_ingredients(matching_ingredients_ids, ingredients.size)
  end

  private

  attr_reader :search_params

  def ingredient_query
    @ingredient_query ||= search_params.to_s.strip
  end

  def ingredients
    @ingredients ||= ingredient_query.split(",").map(&:strip).reject(&:blank?)
  end

  def matching_ingredients_ids
    @matching_ingredients_ids ||= ingredients.flat_map do |ingredient|
      Ingredient.search_by_name(ingredient).pluck(:id)
    end
  end

  def query_without_commas
    @query_without_commas ||= ingredient_query.gsub(",", "").strip
  end
end

class RecipesController < ApplicationController
  def search
    ingredient_query = params[:ingredient_search].to_s.strip

    query_without_commas = ingredient_query.gsub(",", "").strip

    if query_without_commas.length < 2
      @recipes = []
    else
      ingredients = ingredient_query.split(",").map(&:strip).reject(&:blank?)
      matching_ingredients = ingredients.flat_map do |ingredient|
        Ingredient.search_by_name(ingredient).pluck(:id)
      end

      if matching_ingredients.any?
        @recipes = Recipe.joins(:recipe_ingredients)
                         .where(recipe_ingredients: { ingredient_id: matching_ingredients })
                         .group("recipes.id")
                         .having("COUNT(DISTINCT recipe_ingredients.ingredient_id) >= ?", ingredients.size)
      else
        @recipes = []
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_results",
          partial: "recipes/search_results",
          locals: { recipes: @recipes }
        )
      end
    end
  end
end

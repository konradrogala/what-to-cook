class RecipesController < ApplicationController
  include Pagy::Backend
  def search
    ingredient_query = params[:ingredient_search].to_s.strip

    # Usuń spacje i przecinki, aby sprawdzić minimalną długość zapytania
    query_without_commas = ingredient_query.gsub(",", "").strip

    if query_without_commas.length < 2
      @recipes = []
    else
      # Podziel zapytanie na poszczególne składniki
      ingredients = ingredient_query.split(",").map(&:strip).reject(&:blank?)

      # Wyszukaj składniki za pomocą pg_search
      matching_ingredients = ingredients.flat_map do |ingredient|
        Ingredient.search_by_name(ingredient).pluck(:id)
      end

      if matching_ingredients.any?
        # Znajdź przepisy, które mają wszystkie dopasowane składniki
        @recipes = Recipe.joins(:recipe_ingredients)
                         .where(recipe_ingredients: { ingredient_id: matching_ingredients })
                         .group("recipes.id")
                         .having("COUNT(DISTINCT recipe_ingredients.ingredient_id) >= ?", ingredients.size)
      else
        @recipes = []
      end
    end

    @pagy, @records = pagy_countless(@recipes, item: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end

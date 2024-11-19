class RecipesController < ApplicationController
  def search
    ingredient_query = params[:ingredient_search].to_s.strip

    query_without_commas = ingredient_query.gsub(",", "").strip

    if query_without_commas.length < 2
      @recipes = []
    else
      ingredients = ingredient_query.split(",").map(&:strip).reject(&:blank?)

      @recipes = if ingredients.any?
                   Recipe.joins(:ingredients)
                         .where("ingredients.name ILIKE ANY (ARRAY[?])", ingredients.map { |i| "%#{i}%" })
                         .distinct
                         .includes(:ingredients) # Eager loading for widok
      else
                   []
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

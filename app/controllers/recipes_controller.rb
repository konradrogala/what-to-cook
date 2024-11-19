class RecipesController < ApplicationController
  def search
    ingredient_query = params[:ingredient_search] || ""

    if ingredient_query.blank?
      @recipes = []
    else
      ingredients = ingredient_query.split(",").map(&:strip)

      @recipes = Recipe.joins(:ingredients)
      .where("ingredients.name ILIKE ANY (ARRAY[?])", ingredients.map { |i| "%#{i}%" })
      .distinct
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

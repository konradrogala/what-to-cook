class RecipesController < ApplicationController
  def show
    @recipe = Recipe.includes(:ingredients).find(params[:id])
  end

  def search
    @recipes = FindRecipesByIngredients.new(params[:ingredient_search]).result

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

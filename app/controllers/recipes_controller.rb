class RecipesController < ApplicationController
  def show
    @recipe = Recipe.includes(:ingredients).find(permitted_params[:id])
  end

  def search
    @recipes = FindRecipesByIngredients.new(permitted_params[:ingredient_search]).result

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

  private

  def permitted_params
    params.permit(:id, :ingredient_search)
  end
end

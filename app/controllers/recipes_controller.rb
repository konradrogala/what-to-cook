class RecipesController < ApplicationController
  include Pagy::Backend
  def show
    @recipe = Recipe.includes(:ingredients).find(permitted_params[:id])
  end

  def search
    @pagy, @recipes = pagy_countless(FindRecipesByIngredients.new(permitted_params[:ingredient_search]).result)

    respond_to do |format|
      format.turbo_stream
      format.any { head :not_acceptable }
    end
  end

  private

  def permitted_params
    params.permit(:id, :ingredient_search, :page)
  end
end

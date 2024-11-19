class RecipesController < ApplicationController
  def index
    if params[:query].present?
      @recipes = Recipe.where("title LIKE ?", "%#{params[:query]}%").order(:title)
    else
      @recipes = Recipe.all.order(:title)
    end
  end

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

  private

  def search_recipes_by_ingredients(user_ingredients)
    Recipe.joins(:ingredients)
          .where(ingredients: { name: user_ingredients })
          .distinct
  end

  def search_recipes_by_all_ingredients(user_ingredients)
    Recipe.joins(:ingredients)
          .where(ingredients: { name: user_ingredients })
          .group("recipes.id")
          .having("COUNT(ingredients.id) = ?", user_ingredients.size)
  end
end

require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  describe 'GET #show' do
    let(:recipe) { create(:recipe) }
    let!(:ingredient) { create(:ingredient) }
    let!(:recipe_ingredient) { create(:recipe_ingredient, recipe: recipe, ingredient: ingredient, amount: "1", unit: "cup") }

    it 'assigns the requested recipe to @recipe' do
      get :show, params: { id: recipe.id }
      expect(assigns(:recipe)).to eq(recipe)
    end

    it 'preloads ingredients for the recipe' do
      get :show, params: { id: recipe.id }
      expect(assigns(:recipe).ingredients).to include(ingredient)
    end

    it 'returns a successful response' do
      get :show, params: { id: recipe.id }
      expect(response).to have_http_status(:ok)
    end
  end
end

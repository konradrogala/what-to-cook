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

  describe 'GET #search' do
    let!(:recipe) { create(:recipe, title: "Spaghetti") }
    let!(:ingredient) { create(:ingredient, name: "Pasta") }
    let!(:recipe_ingredient) { create(:recipe_ingredient, recipe: recipe, ingredient: ingredient) }

    context 'with turbo_stream format' do
      it 'returns a successful response' do
        get :search, params: { ingredient_search: "Pasta" }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @recipes with matching recipes' do
        get :search, params: { ingredient_search: "Pasta" }, format: :turbo_stream
        expect(assigns(:recipes)).to include(recipe)
      end

      it 'renders the turbo_stream template' do
        get :search, params: { ingredient_search: "Pasta" }, format: :turbo_stream
        expect(response).to render_template(:search)
      end
    end

    context 'with non-turbo_stream format' do
      it 'returns not acceptable status' do
        get :search, params: { ingredient_search: "Pasta" }, format: :html
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IngredientService::Creator do
  let(:creator) { described_class.new }
  let(:recipe) { create(:recipe) }
  let(:ingredients) { ["1 cup all-purpose flour", "½ teaspoon salt"] }

  describe '#create_for_recipe' do
    it 'creates ingredients and associates them with the recipe' do
      expect { creator.create_for_recipe(recipe, ingredients) }
        .to change { Ingredient.count }.by(2)
        .and change { RecipeIngredient.count }.by(2)
    end

    it 'creates recipe_ingredients with correct attributes' do
      creator.create_for_recipe(recipe, ingredients)

      first_ingredient = recipe.recipe_ingredients.first
      expect(first_ingredient.amount).to eq("1")
      expect(first_ingredient.unit).to eq("cup")
      expect(first_ingredient.ingredient.name).to eq("all-purpose flour")

      second_ingredient = recipe.recipe_ingredients.second
      expect(second_ingredient.amount).to eq("½")
      expect(second_ingredient.unit).to eq("teaspoon")
      expect(second_ingredient.ingredient.name).to eq("salt")
    end

    context 'when ingredient already exists' do
      before do
        Ingredient.create!(name: "all-purpose flour")
      end

      it 'does not create duplicate ingredients' do
        expect { creator.create_for_recipe(recipe, ingredients) }
          .to change { Ingredient.count }.by(1)
      end

      it 'associates existing ingredient with the recipe' do
        creator.create_for_recipe(recipe, ingredients)
        expect(recipe.ingredients.map(&:name)).to include("all-purpose flour")
      end
    end
  end
end

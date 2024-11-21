# spec/services/find_recipes_by_ingredients_spec.rb
require "rails_helper"

RSpec.describe FindRecipesByIngredients, type: :service do
  describe "#result" do
    let!(:ingredient1) { create(:ingredient, name: "beef") }
    let!(:ingredient2) { create(:ingredient, name: "tomato") }
    let!(:ingredient3) { create(:ingredient, name: "onion") }

    let!(:recipe1) { create(:recipe, title: "Beef Stew") }
    let!(:recipe2) { create(:recipe, title: "Tomato Soup") }
    let!(:recipe3) { create(:recipe, title: "Beef and Tomato Stir Fry") }

    before do
      create(:recipe_ingredient, recipe: recipe1, ingredient: ingredient1)
      create(:recipe_ingredient, recipe: recipe1, ingredient: ingredient3)

      create(:recipe_ingredient, recipe: recipe2, ingredient: ingredient2)

      create(:recipe_ingredient, recipe: recipe3, ingredient: ingredient1)
      create(:recipe_ingredient, recipe: recipe3, ingredient: ingredient2)
    end

    context "when no ingredients are provided" do
      it "returns an empty array" do
        service = described_class.new("")
        expect(service.result).to eq([])
      end
    end

    context "when less than 2 characters are provided" do
      it "returns an empty array" do
        service = described_class.new("b")
        expect(service.result).to eq([])
      end
    end

    context "when one matching ingredient is provided" do
      it "returns recipes with the matching ingredient" do
        service = described_class.new("beef")
        result = service.result
        expect(result).to match_array([ recipe1, recipe3 ])
      end
    end

    context "when multiple matching ingredients are provided" do
      it "returns recipes containing all ingredients" do
        service = described_class.new("beef, tomato")
        result = service.result
        expect(result).to match_array([ recipe3 ])
      end
    end

    context "when no recipes match the provided ingredients" do
      it "returns an empty array" do
        service = described_class.new("chicken, carrot")
        expect(service.result).to eq([])
      end
    end
  end
end

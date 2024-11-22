# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeService::Creator do
  describe '.create' do
    let(:recipe_data) do
      {
        "title" => "Test Recipe",
        "cook_time" => 30,
        "prep_time" => 15,
        "ratings" => 4.5,
        "cuisine" => "Test Cuisine",
        "category" => "Test Category",
        "author" => "Test Author",
        "image" => "http://example.com/image.jpg"
      }
    end

    it 'creates a recipe with correct attributes' do
      recipe = described_class.create(recipe_data)

      expect(recipe).to be_persisted
      expect(recipe.title).to eq("Test Recipe")
      expect(recipe.cook_time).to eq(30)
      expect(recipe.prep_time).to eq(15)
      expect(recipe.rating).to eq(450) # 4.5 * 100
      expect(recipe.cuisine).to eq("Test Cuisine")
      expect(recipe.category).to eq("Test Category")
      expect(recipe.author).to eq("Test Author")
      expect(recipe.image_url).to eq("http://example.com/image.jpg")
    end
  end
end

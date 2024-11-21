require 'rails_helper'

RSpec.describe CreateRecipesFromJson do
  let(:file_path) { Rails.root.join('spec/fixtures/recipes.json') }
  let(:json_data) do
    [
      {
        "title" => "Test Recipe",
        "cook_time" => 30,
        "prep_time" => 15,
        "ingredients" => [ "1 cup all-purpose flour", "½ teaspoon salt" ],
        "ratings" => 4.5,
        "cuisine" => "Test Cuisine",
        "category" => "Test Category",
        "author" => "Test Author",
        "image" => "http://example.com/image.jpg"
      }
    ].to_json
  end

  before do
    File.write(file_path, json_data)
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  describe '#create' do
    subject { described_class.new(file_path) }

    context 'when the JSON file is valid' do
      it 'creates recipes from the JSON file' do
        expect { subject.create }.to change { Recipe.count }.by(1)
      end

      it 'creates ingredients associated with the recipes' do
        expect { subject.create }.to change { Ingredient.count }.by(2)
      end

      it 'creates recipe_ingredients with correct attributes' do
        subject.create
        recipe = Recipe.last
        expect(recipe.recipe_ingredients.count).to eq(2)
        expect(recipe.recipe_ingredients.first.amount).to eq("1")
        expect(recipe.recipe_ingredients.first.unit).to eq("cup")
        expect(recipe.recipe_ingredients.first.ingredient.name).to eq("all-purpose flour")
      end
    end

    context 'when the JSON file is invalid' do
      let(:file_path) { Rails.root.join('spec/fixtures/invalid.json') }

      before do
        File.write(file_path, "invalid json")
      end

      it 'raises a JSON::ParserError' do
        expect { subject.create }.to raise_error(JSON::ParserError)
      end
    end

    context 'when there is a duplicate ingredient' do
      before do
        Ingredient.create!(name: "all-purpose flour")
      end

      it 'does not create duplicate ingredients' do
        expect { subject.create }.to change { Ingredient.count }.by(1)
      end
    end
  end

  describe '#parse_ingredient' do
    let(:instance) { described_class.new(file_path) }

    it 'parses ingredient string correctly' do
      result = instance.send(:parse_ingredient, "1 cup all-purpose flour")
      expect(result).to eq({ amount: "1", unit: "cup", name: "all-purpose flour" })
    end
  end
end

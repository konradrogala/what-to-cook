# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IngredientService::Parser do
  describe '.parse' do
    it 'parses ingredient with amount, unit and name' do
      result = described_class.parse("1 cup all-purpose flour")
      expect(result).to eq(amount: "1", unit: "cup", name: "all-purpose flour")
    end

    it 'parses ingredient with fraction amount' do
      result = described_class.parse("½ teaspoon salt")
      expect(result).to eq(amount: "½", unit: "teaspoon", name: "salt")
    end

    it 'parses ingredient without unit' do
      result = described_class.parse("2 eggs")
      expect(result).to eq(amount: "2", unit: "", name: "eggs")
    end

    it 'parses ingredient without amount' do
      result = described_class.parse("salt to taste")
      expect(result).to eq(amount: "1", unit: "", name: "salt to taste")
    end

    it 'handles invalid ingredient format' do
      result = described_class.parse("")
      expect(result).to have_key(:error)
    end
  end
end

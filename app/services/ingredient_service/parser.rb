# frozen_string_literal: true

module IngredientService
  class Parser
    def self.parse(ingredient)
      return { error: "Nie udało się sparsować: #{ingredient}" } if ingredient.blank?

      if ingredient.match?(/^[\d⅓⅔¾½¼¾\/]/)
        parse_with_amount(ingredient)
      else
        parse_without_amount(ingredient)
      end
    end

    private

    def self.parse_with_amount(ingredient)
      match = ingredient.match(/^([\d\s⅓⅔¾½¼¾\/]+)\s*(\w+)?\s*(.+)?/)
      return { error: "Nie udało się sparsować: #{ingredient}" } unless match

      if match[3].nil? && match[2]
        {
          amount: match[1].strip,
          unit: "",
          name: match[2].strip
        }
      else
        {
          amount: match[1].strip,
          unit: match[2]&.strip || "",
          name: match[3]&.strip || match[2]&.strip || "unknown"
        }
      end
    end

    def self.parse_without_amount(ingredient)
      {
        amount: "1",
        unit: "",
        name: ingredient.strip
      }
    end
  end
end

# frozen_string_literal: true

module Ingredient
  class Parser
    def self.parse(ingredient)
      match = ingredient.match(/^([\d\s⅓⅔¾½¼¾\/]+)?\s*(\(.+?\)\s*\w+|\w+)?\s*(.+)?/)

      if match
        {
          amount: match[1]&.strip || "1",
          unit: extract_unit(match),
          name: match[3]&.strip || match[2]&.strip || "unknown"
        }
      else
        { error: "Nie udało się sparsować: #{ingredient}" }
      end
    end

    private

    def self.extract_unit(match)
      if match[3]&.strip.nil?
        ""
      else
        match[2]&.strip || "piece"
      end
    end
  end
end

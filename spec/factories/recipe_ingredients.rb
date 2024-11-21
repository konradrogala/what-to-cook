FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    amount { rand(1..500).to_s }
    unit { %w[grams cups tablespoons teaspoons].sample }
  end
end

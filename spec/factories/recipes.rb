FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "Recipe #{n}" }
    cook_time { rand(10..60) }
    prep_time { rand(5..30) }
    rating { rand(300..500) }
    cuisine { %w[Italian Mexican Indian].sample }
    image_url { "https://via.placeholder.com/150" }
    author { "Author #{rand(1..10)}" }
    category { %w[Dessert Main Breakfast].sample }
  end
end

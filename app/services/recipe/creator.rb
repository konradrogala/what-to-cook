# frozen_string_literal: true

module Recipe
  class Creator
    def self.create(data)
      ::Recipe.create!(
        title: data["title"],
        cook_time: data["cook_time"],
        prep_time: data["prep_time"],
        rating: (data["ratings"] * 100).to_i,
        cuisine: data["cuisine"],
        author: data["author"],
        category: data["category"],
        image_url: data["image"]
      )
    end
  end
end

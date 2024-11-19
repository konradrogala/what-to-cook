file_path = Rails.root.join("config/initializers", "recipes_en.json")

CreateRecipesFromJson.new(file_path).create

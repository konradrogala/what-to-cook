class CreateRecipesFromJson
  def initialize(file_path)
    @file_path = file_path
  end

  def create
    recipes = JSON.parse(File.read(file_path))

    Recipe.transaction do
      recipes.each do |recipe|
        created_recipe = Recipe.create!(
          title: recipe["title"],
          cook_time: recipe["cook_time"],
          prep_time: recipe["prep_time"],
          rating: recipe["ratings"] * 100,
          cuisine: recipe["cuisine"],
          author: recipe["author"],
          category: recipe["category"],
          image_url: recipe["image"]
        )

        ingredients_data = recipe["ingredients"].map do |ingredient|
          ingredient_data = parse_ingredient(ingredient)

          ingredient_id = existing_ingredients[ingredient_data[:name]] ||
                          Ingredient.create!(name: ingredient_data[:name]).id
          existing_ingredients[ingredient_data[:name]] ||= ingredient_id

          {
            recipe_id: created_recipe.id,
            ingredient_id: ingredient_id,
            amount: ingredient_data[:amount],
            unit: ingredient_data[:unit],
            created_at: Time.now,
            updated_at: Time.now
          }
        end

        RecipeIngredient.insert_all(ingredients_data)

        progressbar(recipes.size).increment
      end
    end
  end

  private

  attr_reader :file_path

  def parse_ingredient(ingredient)
    match = ingredient.match(/^([\d\s⅓⅔¾½¼¾\/]+)?\s*(\(.+?\)\s*\w+|\w+)?\s*(.+)?/)

    if match
      {
        amount: amount(match),
        unit: unit(match),
        name: name(match)
      }
    else
      { error: "Nie udało się sparsować: #{ingredient}" }
    end
  end

  def amount(match)
    match[1]&.strip || "1"
  end

  def unit(match)
    if match[3]&.strip.nil?
      ""
    else
      match[2]&.strip || "piece"
    end
  end

  def name(match)
    match[3]&.strip || match[2]&.strip || "uknown"
  end

  def progressbar(total)
    @progressbar ||= ProgressBar.create(
      title: "Importing Recipes",
      total: total,
      format: "%a %B %p%% %t",
      progress_mark: "#",
      remainder_mark: "."
    )
  end

  def existing_ingredients
    @existing_ingredients ||= Ingredient.pluck(:name, :id).to_h
  end
end

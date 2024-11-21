class CreateRecipesFromJson
  def initialize(file_path)
    @file_path = file_path
  end

  def create
    recipes = parse_recipes

    Recipe.transaction do
      recipes.each_with_index do |recipe_data, index|
        created_recipe = create_recipe(recipe_data)
        create_ingredients_for_recipe(created_recipe, recipe_data["ingredients"])
        update_progress(index + 1, recipes.size)
      end
    end
  end

  private

  attr_reader :file_path

  def parse_recipes
    JSON.parse(File.read(file_path))
  rescue JSON::ParserError => e
    raise "Nie udało się sparsować pliku JSON: #{e.message}"
  end

  def create_recipe(data)
    Recipe.create!(
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

  def create_ingredients_for_recipe(recipe, ingredients)
    ingredients_data = ingredients.map { |ingredient| prepare_ingredient_data(recipe, ingredient) }
    RecipeIngredient.insert_all(ingredients_data)
  end

  def prepare_ingredient_data(recipe, ingredient)
    ingredient_data = parse_ingredient(ingredient)
    ingredient_id = find_or_create_ingredient(ingredient_data[:name])

    {
      recipe_id: recipe.id,
      ingredient_id: ingredient_id,
      amount: ingredient_data[:amount],
      unit: ingredient_data[:unit]
    }
  end

  def find_or_create_ingredient(name)
    existing_ingredients[name] ||= Ingredient.create!(name: name).id
  end

  def update_progress(current, total)
    progressbar(total).increment if current <= total
  end

  def parse_ingredient(ingredient)
    match = ingredient.match(/^([\d\s⅓⅔¾½¼¾\/]+)?\s*(\(.+?\)\s*\w+|\w+)?\s*(.+)?/)

    if match
      {
        amount: match[1]&.strip || "1",
        unit: unit(match),
        name: match[3]&.strip || match[2]&.strip || "unknown"
      }
    else
      { error: "Nie udało się sparsować: #{ingredient}" }
    end
  end

  def unit(match)
    if match[3]&.strip.nil?
      ""
    else
      match[2]&.strip || "piece"
    end
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

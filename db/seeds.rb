file_path = Rails.root.join('config/initializers', 'recipes_en.json')
recipes = JSON.parse(File.read(file_path))

def parse_ingredient(ingredient)
  match = ingredient.match(/^([\d\s⅓⅔¾½¼¾\/]+)?\s*(\(.+?\)\s*\w+|\w+)?\s*(.+)$/)

  if match
    amount = match[1]&.strip || "1"
    unit = match[2]&.strip || "piece"
    name = match[3]&.strip || ""

    if name.downcase.include?("cooking spray")
      unit = "spray can"
    end

    {
      amount: amount,
      unit: unit,
      name: name
    }
  else
    { error: "Nie udało się sparsować: #{ingredient}" }
  end
end

progressbar = ProgressBar.create(
  title: 'Importing Recipes',
  total: recipes.size,
  format: '%a %B %p%% %t',
  progress_mark: '#',
  remainder_mark: '.'
)

existing_ingredients = Ingredient.pluck(:name, :id).to_h

Recipe.transaction do
  recipes.each do |recipe|
    created_recipe = Recipe.create!(
      title: recipe['title'],
      cook_time: recipe['cook_time'],
      prep_time: recipe['prep_time'],
      rating: recipe['ratings'] * 100,
      cuisine: recipe['cuisine'],
      author: recipe['author'],
      category: recipe['category'],
      image_url: recipe['image']
    )

    ingredients_data = recipe['ingredients'].map do |ingredient|
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

    progressbar.increment
  end
end


puts "Data imported correctly!"

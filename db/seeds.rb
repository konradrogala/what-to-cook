# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# require 'json'

file_path = Rails.root.join('config/initializers', 'recipes_en.json')
recipes = JSON.parse(File.read(file_path))
recipes.each do |recipe|
  Recipe.create!(
    title: recipe['title'],
    cook_time: recipe['cook_time'],
    prep_time: recipe['prep_time'],
    rating: recipe['ratings'] * 100,
    cuisine: recipe['cuisine'],
    author: recipe['author'],
    category: recipe['category'],
    image_url: recipe['image']
  )
end

puts "Data imported correctly!"

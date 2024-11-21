# README

WHAT TO COOK

App based on data fetch from www.allrecipes.com 

To run this properly you should install Ruby 3.3.4 version and Postgresql.

After creating databse, you can user rails db:seed to create records in your local database. This may take a while.


User Stories:

* Finding Recipe provided by the user
  User can simply type, full or part of the name of the ingredient and app should return all recipes that contains this ingredient.
  User can write down more than one ingredient using "," to seperate ingredients. Like "bacon, egg". App returns all recipes that contain, that two ingredients and more.

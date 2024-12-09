class AddPgSearchExtensions < ActiveRecord::Migration[7.2]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm;'
  end
end

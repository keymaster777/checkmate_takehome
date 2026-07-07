# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def parse_markdown_table(path)
  lines = File.readlines(path)
              .map(&:strip)
              .reject(&:empty?)

  headers = lines[0]
              .split("|")
              .map(&:strip)
              .reject(&:empty?)

  data = lines.drop(2)

  data.map do |line|
    values = line.split("|")
                 .map(&:strip)
                 .reject(&:empty?)

    headers.zip(values).to_h
  end
end

puts "Seeding menu items"
parse_markdown_table(Rails.root.join("db/menu_items.txt")).each do |row|
  MenuItem.create!(
    id: row["item_id"].to_i,
    name: row["name"],
    price_cents: row["price_cents"].to_i,
    prep_seconds: row["prep_seconds"].to_i
  )
end
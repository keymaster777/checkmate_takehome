FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    price_cents { 999 }
    prep_seconds { 120 }
  end
end
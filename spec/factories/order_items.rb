FactoryBot.define do
  factory :order_item do
    order
    menu_item
    qty { 1 }
  end
end
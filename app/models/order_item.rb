class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :qty, numericality: { only_integer: true, greater_than: 0 }
end

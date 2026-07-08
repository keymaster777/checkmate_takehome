class Order < ApplicationRecord
    has_many :order_items, dependent: :destroy
    has_many :menu_items, through: :order_items

    accepts_nested_attributes_for :order_items

    before_save :build_order_details

    def build_order_details
        self.subtotal_cents = order_items.sum { |oi| oi.menu_item.price_cents * oi.qty }
        if self.subtotal_cents >= 2000
            self.discount_cents = (self.subtotal_cents * 0.1).to_i
        end
        self.estimated_prep_seconds = order_items.sum { |oi| oi.menu_item.prep_seconds * oi.qty }
        self.total_cents = self.subtotal_cents - self.discount_cents
    end
end

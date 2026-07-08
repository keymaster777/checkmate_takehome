require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it 'is invalid when qty is less than 1' do
      order_item = OrderItem.new(qty: 0)

      expect(order_item).not_to be_valid
      expect(order_item.errors[:qty]).to be_present
    end

    it 'is invalid when qty is negative' do
      order_item = OrderItem.new(qty: -5)

      expect(order_item).not_to be_valid
    end

    it 'is valid when qty is 1 or greater' do
      order_item = OrderItem.new(qty: 1)

      order_item.valid?
      expect(order_item.errors[:qty]).to be_empty
    end

    it 'is invalid when menu_item is missing' do
      order_item = OrderItem.new(qty: 1, menu_item: nil)

      expect(order_item).not_to be_valid
      expect(order_item.errors[:menu_item]).to be_present
    end
  end
end
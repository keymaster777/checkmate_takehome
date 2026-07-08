require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { Order.new }

  def stub_order_items(items)
    # items: array of [price_cents, prep_seconds, qty]
    doubles = items.map do |price_cents, prep_seconds, qty|
      menu_item = instance_double(MenuItem, price_cents: price_cents, prep_seconds: prep_seconds)
      instance_double(OrderItem, menu_item: menu_item, qty: qty)
    end
    allow(order).to receive(:order_items).and_return(doubles)
  end

  describe '#get_prep_schedule' do
    it 'assigns items to the lowest-loaded station' do
      stub_order_items([[500, 100, 1], [300, 80, 1], [200, 60, 1]])

      expect(order.send(:get_prep_schedule)).to eq([[1, 100], [2, 140]])
    end

    it 'returns STATION_COUNT entries even with no items' do
      stub_order_items([])

      expect(order.send(:get_prep_schedule)).to eq([[1, 0], [2, 0]])
    end
  end

  describe '#build_order_details' do
    it 'sums subtotal and applies no discount below threshold' do
      stub_order_items([[500, 100, 1], [300, 80, 1]])

      order.send(:build_order_details)

      expect(order.subtotal_cents).to eq(800)
      expect(order.discount_cents).to eq(0)
      expect(order.total_cents).to eq(800)
    end

    it 'applies a 10% discount at or above the threshold' do
      stub_order_items([[2000, 100, 1]])

      order.send(:build_order_details)

      expect(order.subtotal_cents).to eq(2000)
      expect(order.discount_cents).to eq(200)
      expect(order.total_cents).to eq(1800)
    end

    it 'sets estimated_prep_seconds to the busiest station total' do
      stub_order_items([[500, 100, 1], [300, 80, 1], [200, 60, 1]])

      order.send(:build_order_details)

      expect(order.prep_schedule).to eq([[2, 140], [1, 100]])
      expect(order.estimated_prep_seconds).to eq(140)
    end
  end
end
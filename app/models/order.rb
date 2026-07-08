class Order < ApplicationRecord
    has_many :order_items, dependent: :destroy
    has_many :menu_items, through: :order_items

    accepts_nested_attributes_for :order_items

    before_save :build_order_details

    private

    DISCOUNT_THRESHOLD_CENTS = 2000
    DISCOUNT_RATE = 0.1
    STATION_COUNT = 2

    def build_order_details
        self.subtotal_cents = order_items.sum { |oi| oi.menu_item.price_cents * oi.qty }
        if subtotal_cents >= DISCOUNT_THRESHOLD_CENTS
            self.discount_cents = (subtotal_cents * DISCOUNT_RATE).to_i
        end
        self.total_cents = subtotal_cents - discount_cents
        self.prep_schedule = get_prep_schedule
        self.estimated_prep_seconds = prep_schedule.map{|station_time| station_time[1]}.max
    end


    def get_prep_schedule
        station_totals = Array.new(STATION_COUNT, 0)

        order_items.each do |oi|
            prep_time = oi.menu_item.prep_seconds * oi.qty
            station_index = station_totals.index(station_totals.min)
            station_totals[station_index] += prep_time
        end

        station_totals.each_with_index.map { |total, index| [index + 1, total] }.sort_by(&:last).reverse
    end
end

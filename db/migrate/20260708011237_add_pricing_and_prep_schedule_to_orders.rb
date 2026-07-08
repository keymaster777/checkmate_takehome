class AddPricingAndPrepScheduleToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :subtotal_cents, :integer, null: false, default: 0
    add_column :orders, :discount_cents, :integer, null: false, default: 0
    add_column :orders, :total_cents, :integer, null: false, default: 0
    add_column :orders, :estimated_prep_seconds, :integer, null: false, default: 0
    add_column :orders, :prep_schedule, :jsonb, null: false, default: []
  end
end

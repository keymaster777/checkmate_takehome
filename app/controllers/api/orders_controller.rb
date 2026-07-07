class Api::OrdersController < ApplicationController
    # Should have spun up the rails project with the API flag
    skip_before_action :verify_authenticity_token

    def create
        order = Order.create!

        params[:items].each do |item|
            order.order_items.create!(
            menu_item_id: item[:item_id],
            qty: item[:qty]
            )
        end

        render json: order, status: :created
    end
end

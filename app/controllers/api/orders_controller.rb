class Api::OrdersController < ApplicationController
    # Should have spun up the rails project with the API flag
    skip_before_action :verify_authenticity_token

    def create
        return unless validate_items_param

        order = nil

        begin
        Order.transaction do
            order = Order.create!

            params[:items].each do |item|
                menu_item = MenuItem.find(item[:item_id])

                order.order_items.create!(
                    menu_item: menu_item,
                    qty: item[:qty]
                )
            end
        end

        render json: order, status: :created

        # Catching any active record error, we may want to handle other errors differently
        rescue ActiveRecord::ActiveRecordError => e
            render json: {
                error: e.message,
            }, status: :bad_request
        end
    end

    private

    def validate_items_param
        if params[:items].blank?
            render json: {
            error: "items is required and cannot be empty"
            }, status: :bad_request

            return false
        end
        true
    end
end

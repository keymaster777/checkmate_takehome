class Api::OrdersController < ApplicationController
    # Should have spun up the rails project with the API flag
    skip_before_action :verify_authenticity_token

    def create
        return unless validate_items_param


        begin
        order = Order.create!(order_params)

        render json: order, status: :created

        # Catching any active record error, we may want to handle other errors differently
        rescue ActiveRecord::ActiveRecordError => e
            render json: { error: e.message }, status: :bad_request
        end
    end

    private

    def validate_items_param
        if params[:items].blank?
            render json: { error: "items is required and cannot be empty" }, status: :bad_request
            return false
        end
        true
    end

    def order_params
        {
            order_items_attributes: params[:items].map { |item|
                { menu_item_id: item[:item_id], qty: item[:qty] }
            }
        }
    end
end

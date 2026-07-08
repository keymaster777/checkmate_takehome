require 'rails_helper'

RSpec.describe Api::OrdersController, type: :request do
  describe 'POST /api/orders' do
    let!(:menu_item_1) { MenuItem.create!(name: 'Burger', price_cents: 1200, prep_seconds: 300) }
    let!(:menu_item_2) { MenuItem.create!(name: 'Fries', price_cents: 400, prep_seconds: 120) }

    context 'with valid items' do
      let(:valid_params) do
        {
          items: [
            { item_id: menu_item_1.id, qty: 2 },
            { item_id: menu_item_2.id, qty: 1 }
          ]
        }
      end

      it 'creates an order' do
        expect {
          post '/api/orders', params: valid_params, as: :json
        }.to change(Order, :count).by(1)
      end

      it 'creates order_items for each item' do
        expect {
          post '/api/orders', params: valid_params, as: :json
        }.to change(OrderItem, :count).by(2)
      end

      it 'returns a created status' do
        post '/api/orders', params: valid_params, as: :json

        expect(response).to have_http_status(:created)
      end

      it 'returns the calculated subtotal_cents' do
        post '/api/orders', params: valid_params, as: :json

        json = JSON.parse(response.body)
        expect(json['subtotal_cents']).to eq(2800) # (1200 * 2) + (400 * 1)
      end
    end

    context 'when items param is missing' do
      it 'does not create an order' do
        expect {
          post '/api/orders', params: {}, as: :json
        }.not_to change(Order, :count)
      end

      it 'returns a bad_request status' do
        post '/api/orders', params: {}, as: :json

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post '/api/orders', params: {}, as: :json

        json = JSON.parse(response.body)
        expect(json['error']).to eq('items is required and cannot be empty')
      end
    end

    context 'when items param is an empty array' do
      it 'returns a bad_request status' do
        post '/api/orders', params: { items: [] }, as: :json

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when an item references a menu_item that does not exist' do
      let(:invalid_params) do
        { items: [{ item_id: -1, qty: 1 }] }
      end

      it 'does not create an order' do
        expect {
          post '/api/orders', params: invalid_params, as: :json
        }.not_to change(Order, :count)
      end

      it 'returns a bad_request status' do
        post '/api/orders', params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        post '/api/orders', params: invalid_params, as: :json

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'when qty is less than 1' do
      let(:invalid_params) do
        { items: [{ item_id: menu_item_1.id, qty: 0 }] }
      end

      it 'does not create an order' do
        expect {
          post '/api/orders', params: invalid_params, as: :json
        }.not_to change(Order, :count)
      end

      it 'returns a bad_request status' do
        post '/api/orders', params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
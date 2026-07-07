class ApiController < ApplicationController

    def ping
        items = MenuItem.all
        #render json: { message: "pong" }
        render json: items
    end
end

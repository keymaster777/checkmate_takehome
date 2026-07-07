class ApiController < ApplicationController

    def ping
        render json: { message: "pong" }
    end
end

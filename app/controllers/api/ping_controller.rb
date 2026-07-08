class Api::PingController < ApplicationController

    def ping
        render json: { message: "pong" }
    end
end

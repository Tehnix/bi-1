class ErrorsController < ApplicationController

  def not_found
    render json: { error: "not-found" }, status: 404
  end

  def exception
    render json: { error: "internal-server-error" }, status: 500
  end

end

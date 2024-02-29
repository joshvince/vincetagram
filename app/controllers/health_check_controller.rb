# frozen_string_literal: true

class HealthCheckController < ApplicationController
  def up
    respond_to do |format|
      format.json { render json: { status: :ok }, status: :ok }
      format.html { render plain: 'ok', status: :ok }
    end
  end
end

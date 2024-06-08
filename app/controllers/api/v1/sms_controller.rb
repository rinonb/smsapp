class Api::V1::SmsController < ApplicationController
  rescue_from InvalidSmsPayload, with: :invalid_sms_payload

  def create
    result = SmsDeliveryService.call(**sms_params)
    render json: result
  end

  private

  def invalid_sms_payload(error)
    render json: { error: "Invalid payload", details: error }, status: :unprocessable_entity
  end

  def sms_params
    params.permit(:text, :sender, :receiver).to_h.symbolize_keys
  end
end

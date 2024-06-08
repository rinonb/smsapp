class Api::V1::SmsController < ApplicationController
  class InvalidSmsPayload < StandardError; end

  before_action :validate_payload!, only: :create
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

  def validate_payload!
    contract = SmsContract.new.call(sms_params)
    raise InvalidSmsPayload, contract.errors.to_h if contract.failure?
  end
end

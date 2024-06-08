# frozen_string_literal: true

class SmsDeliveryService
  def self.call(text:, sender:, receiver:)
    new(text, sender, receiver).call
  end

  attr_reader :sender, :receiver
  attr_accessor :text, :message

  def initialize(text, sender, receiver)
    @text = text
    @message = nil
    @sender = sender
    @receiver = receiver
  end

  def call
    message_parts = MessagesCreatorService.call(text:, sender:, receiver:)
    message_parts.map { |part| deliver(part) }
  end

  def deliver(message_part)
    SmsProviderClient.call(sender:, receiver:, text: message_part.text)
  end
end

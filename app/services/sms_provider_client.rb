class SmsProviderClient
  def self.call(text:, sender:, receiver:)
    new(text, sender, receiver).deliver
  end

  attr_reader :text, :sender, :receiver

  def initialize(text, sender, receiver)
    @text = text
    @sender = sender
    @receiver = receiver
  end

  def deliver
    success_response
  end

  private

  def success_response
    { status: 201, result: "#{text} from #{sender} to #{receiver} sent" }
  end

  def error_response
    { status: 500, result: "Failed to send #{text} from #{sender} to #{receiver}" }
  end
end

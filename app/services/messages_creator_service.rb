# frozen_string_literal: true

class MessagesCreatorService
  MESSAGE_TYPE = {
    single: :single,
    multiple: :multiple
  }.freeze

  def self.call(text:, sender:, receiver:)
    new(text, sender, receiver).call
  end

  attr_reader :sender, :text, :receiver, :max_length, :text_type
  attr_accessor :message

  def initialize(text, sender, receiver)
    contract = SmsContract.new.call({ text:, sender:, receiver: })
    raise InvalidSmsPayload, contract.errors.to_h if contract.failure?

    @text = text
    @sender = sender
    @receiver = receiver
    @max_length = MessagePart::MAX_MESSAGE_LENGTH
    @text_type = text.length > max_length ? MESSAGE_TYPE[:multiple] : MESSAGE_TYPE[:single]
  end

  def call
    self.message = Message.create(sender:, receiver:)

    message_records =
      if single_type_text?
        single_message
      else
        multiple_messages
      end

    Array(message_records)
  end

  private

  def single_message
    message.message_parts.create(text:, part: 1, status: 'created')
  end

  def multiple_messages(input_message = text, parts = [])
    part = parts.count + 1
    truncation = truncate_message(input_message, part)
    truncated_message, text = truncation.values_at(:truncated_message, :text)

    message_part = message.message_parts.create(text:, part:, status: 'created')

    truncated_message_length = truncated_message.length
    new_input_message = input_message[truncated_message_length..]&.strip

    parts << message_part

    return multiple_messages(new_input_message, parts) if new_input_message&.length&.positive?

    parts
  end

  def truncate_message(input_message, part)
    suffix = "- part #{part}"
    message_length = max_length - suffix.length
    truncated_message = input_message.truncate(message_length, separator: ' ', omission: '')
    text = "#{truncated_message}#{suffix}"

    {
      truncated_message:,
      text:
    }
  end

  def single_type_text?
    text_type == MESSAGE_TYPE[:single]
  end

  def multiple_type_text?
    text_type == MESSAGE_TYPE[:multiple]
  end
end

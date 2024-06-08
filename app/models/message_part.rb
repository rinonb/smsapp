class MessagePart < ApplicationRecord
  MAX_MESSAGE_LENGTH = 160

  belongs_to :message

  validates_presence_of :message, :part, :status
  validates :text, presence: true, length: { maximum: MAX_MESSAGE_LENGTH }
end

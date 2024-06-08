class Message < ApplicationRecord
  validates_presence_of :sender, :receiver
  has_many :message_parts
end

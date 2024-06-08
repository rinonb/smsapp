# frozen_string_literal: true

class Message < ApplicationRecord
  validates_presence_of :sender, :receiver
  has_many :message_parts, dependent: :destroy
end

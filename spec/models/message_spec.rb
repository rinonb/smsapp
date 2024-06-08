require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it 'should be invalid when sender or receiver is not present' do
      expect(Message.new).to_not be_valid
    end
  end

  describe 'associations' do
    it 'should delete message_parts when message is deleted' do
      message = Message.create(sender: 'sender', receiver: 'receiver')
      message.message_parts.create(text: 'text', part: 1, status: 'created')
      expect { message.destroy }.to change { MessagePart.count }.by(-1)
    end
  end
end

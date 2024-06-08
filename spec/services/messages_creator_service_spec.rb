require 'rails_helper'

RSpec.shared_examples 'it should create message records' do
  # it 'should create message record' do
  #   subject.call(sender:, receiver:, text:)
  #   expect(Message.find_by(sender:, receiver:)).to be_present
  # end

  it 'should create message part records' do
    subject.call(sender:, receiver:, text:)
    message = Message.find_by(sender:, receiver:)
    expect(message.message_parts.pluck(:text)).to eq(expected_parts)
  end
end

RSpec.describe MessagesCreatorService, type: :service do
  let(:subject) { MessagesCreatorService }

  describe '#call' do
    context 'when sender or receiver is invalid' do
      it 'should raise InvalidSmsPayload' do
        expect do
          subject.call(
            sender: 'sender',
            receiver: 'receiver',
            text: 'text'
          )
        end.to raise_error(InvalidSmsPayload)
      end
    end

    context 'when message is under 160 characters' do
      let(:sender) { '+492123456789' }
      let(:receiver) { '+492123456790' }
      let(:text) { 'text' }
      let(:expected_parts) { [text] }

      it_behaves_like 'it should create message records'
    end

    context 'when message is exactly 160 characters' do
      let(:sender) { '+492123456100' }
      let(:receiver) { '+492123456101' }
      let(:text) { 'a' * 160 }
      let(:expected_parts) { [text] }

      it_behaves_like 'it should create message records'
    end

    context 'when message is over 160 characters' do
      let(:sender) { '+492123456100' }
      let(:receiver) { '+492123456101' }
      let(:text) { 'a' * 165 }
      let(:expected_parts) do
        [
          'a' * (160 - '- part 1'.length) + '- part 1',
          'a' * (5 + '- part 1'.length) + '- part 2'
        ]
      end

      it_behaves_like 'it should create message records'
    end

    context 'when message contains more than 160 characters and words' do
      let(:sender) { '+492123456100' }
      let(:receiver) { '+492123456101' }
      let(:text) { "#{'a' * 85} #{'b' * 85}" }
      let(:expected_parts) do
        [
          'a' * 85 + '- part 1',
          'b' * 85 + '- part 2'
        ]
      end

      it_behaves_like 'it should create message records'
    end
  end
end

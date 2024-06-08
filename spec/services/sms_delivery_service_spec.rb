# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'should call SmsProviderClient' do
  it 'should call SmsProviderClient' do
    subject.call(sender:, receiver:, text:)

    expect(SmsProviderClient).to have_received(:call).with(
      sender:,
      receiver:,
      text:
    )
  end
end

RSpec.describe SmsDeliveryService, type: :service do
  let(:subject) { SmsDeliveryService }
  let(:response) { { status: 201 } }

  before do
    allow(SmsProviderClient).to(
      receive(:call).and_return(true)
    )
  end

  describe '#call' do
    context 'when sender or receiver is invalid' do
      it 'should raise InvalidSmsPayload' do
        expect do
          SmsDeliveryService.call(
            sender: 'sender',
            receiver: 'receiver',
            text: 'text'
          )
        end.to raise_error(InvalidSmsPayload)
      end
    end

    context 'when params are valid' do
      before do
        allow(MessagesCreatorService).to(
          receive(:call).and_return([MessagePart.new(text: 'text')])
        )
      end

      let(:sender) { '+492123456789' }
      let(:receiver) { '+492123456790' }
      let(:text) { 'text' }

      it 'should call MessagesCreatorService' do
        subject.call(sender:, receiver:, text:)

        expect(MessagesCreatorService).to have_received(:call).with(
          text:,
          sender:,
          receiver:
        )
      end

      it_behaves_like 'should call SmsProviderClient'
    end
  end
end

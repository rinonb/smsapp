require 'rails_helper'

RSpec.describe "Api::V1::Sms", type: :request do
  describe "POST /index" do
    context 'when params are valid' do
      let(:sender) { '+492123456789' }
      let(:receiver) { '+492123456790' }
      let(:text) { 'text' }

      before do
        allow(SmsDeliveryService).to receive(:call).and_return({
          result: "#{text} from #{sender} to #{receiver} sent"
        })
      end

      it 'should return successful response' do
        post '/api/v1/sms', params: {
          sender:,
          receiver:,
          text:
        }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body['result']).to eq("#{text} from #{sender} to #{receiver} sent")
      end
    end

    context 'when params are invalid' do
      it 'should return invalid sms payload error' do
        post '/api/v1/sms', params: {
          sender: 'sender',
          receiver: 'receiver',
          text: 'text'
        }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body['error']).to eq('Invalid payload')
      end
    end
  end
end

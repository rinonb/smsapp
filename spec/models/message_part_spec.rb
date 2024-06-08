# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagePart, type: :model do
  describe 'validations' do
    it 'should be invalid when text is not present' do
      expect(MessagePart.new).to_not be_valid
    end

    it 'should be invalid when text is longer than 160 characters' do
      expect(MessagePart.new(text: 'a' * 161)).to_not be_valid
    end
  end
end

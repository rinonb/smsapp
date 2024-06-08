# frozen_string_literal: true

class MakeResponseFieldsNullableInMessagePart < ActiveRecord::Migration[7.1]
  def change
    change_column_null :message_parts, :response_code, true
    change_column_null :message_parts, :response_message, true
  end
end

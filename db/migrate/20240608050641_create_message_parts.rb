class CreateMessageParts < ActiveRecord::Migration[7.1]
  def change
    create_table :message_parts do |t|
      t.references :message, null: false, foreign_key: true
      t.string :text, null: false, limit: 160
      t.integer :part, null: false
      t.string :status, null: false, default: 'created'
      t.integer :response_code, null: false
      t.string :response_message, null: false

      t.timestamps
    end
  end
end

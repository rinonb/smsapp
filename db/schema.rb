# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_608_214_822) do
  create_table 'message_parts', force: :cascade do |t|
    t.integer 'message_id', null: false
    t.string 'text', limit: 160, null: false
    t.integer 'part', null: false
    t.string 'status', default: 'created', null: false
    t.integer 'response_code'
    t.string 'response_message'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['message_id'], name: 'index_message_parts_on_message_id'
  end

  create_table 'messages', force: :cascade do |t|
    t.string 'sender', null: false
    t.string 'receiver', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'message_parts', 'messages'
end

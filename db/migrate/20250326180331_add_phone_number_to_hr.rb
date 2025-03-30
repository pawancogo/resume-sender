# frozen_string_literal: true

class AddPhoneNumberToHr < ActiveRecord::Migration[7.1]
  def change
    add_column :human_resources, :phone_number, :string
  end
end

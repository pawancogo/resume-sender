# frozen_string_literal: true

class CreateHumanResource < ActiveRecord::Migration[7.1]
  def change
    create_table :human_resources do |t|
      t.string :name
      t.string :email
      t.integer :company_id
      t.timestamps
    end
  end
end

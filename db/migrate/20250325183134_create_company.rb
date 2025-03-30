# frozen_string_literal: true

class CreateCompany < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :web_url
      t.string :email
      t.timestamps
    end
  end
end

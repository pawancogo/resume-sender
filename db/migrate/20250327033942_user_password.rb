# frozen_string_literal: true

class UserPassword < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password
    add_column :users, :password_digest, :string
  end
end

# frozen_string_literal: true

class AddDiabledAtColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :disabled_at, :datetime
    add_column :resumes, :disabled_at, :datetime
    add_column :companies, :disabled_at, :datetime
    add_column :human_resources, :disabled_at, :datetime
  end
end

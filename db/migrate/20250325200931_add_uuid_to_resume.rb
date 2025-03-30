# frozen_string_literal: true

class AddUuidToResume < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :uuid, :string
  end
end

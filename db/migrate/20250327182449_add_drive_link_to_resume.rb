# frozen_string_literal: true

class AddDriveLinkToResume < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :public_url, :string
  end
end

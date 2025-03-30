# frozen_string_literal: true

class CreateResume < ActiveRecord::Migration[7.1]
  def change
    create_table :resumes do |t|
      t.string :file
      t.integer :user_id
      t.string :subject
      t.string :description
      t.string :title
      t.timestamps
    end
  end
end

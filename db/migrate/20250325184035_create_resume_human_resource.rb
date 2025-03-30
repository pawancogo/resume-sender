# frozen_string_literal: true

class CreateResumeHumanResource < ActiveRecord::Migration[7.1]
  def change
    create_table :resume_human_resources do |t|
      t.integer :human_resource_id
      t.integer :resume_id
      t.string :status
      t.datetime :applied_at
      t.timestamps
    end
  end
end

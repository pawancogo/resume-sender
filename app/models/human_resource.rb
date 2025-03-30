# frozen_string_literal: true

class HumanResource < ApplicationRecord
  belongs_to :company, optional: true
  has_many :resume_human_resources, dependent: :destroy
  has_many :human_resources, through: :resume_human_resources

  scope :active, -> { where(disabled_at: nil) }

  before_create :set_name, if: -> { !name.present? }

  private

  def set_name
    self.name = email.split('@').first.split('.').first.gsub(/[^a-zA-Z]/, '')
  end
end

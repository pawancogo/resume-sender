# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :human_resources, dependent: :nullify

  scope :active, -> { where(disabled_at: nil) }
end

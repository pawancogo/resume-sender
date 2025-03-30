# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :password, presence: true
  has_many :resumes, dependent: :destroy
  has_one :active_resume, -> { where('disabled_at IS NULL') }, class_name: 'Resume'
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end

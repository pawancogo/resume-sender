# frozen_string_literal: true

class ResumeHumanResource < ApplicationRecord
  belongs_to :resume
  belongs_to :human_resource
  enum status: { pending: 'pending', accepted: 'accepted', rejected: 'rejected' }
end

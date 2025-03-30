# frozen_string_literal: true

class Resume < ApplicationRecord
  belongs_to :user
  has_many :resume_human_resources, dependent: :destroy
  has_many :human_resources, through: :resume_human_resources

  # file uploaded on cloudinary but not getting public url so skipping
  # mount_uploader :file, ResumeUploader # Attach the uploader

  before_create :set_uuid
  # before_save :set_inactive, if: ->{ will_save_change_to_status}

  before_destroy :remove_file_from_cloudinary
  before_update :remove_old_file_from_cloudinary, if: :will_save_change_to_file?

  private

  # Delete the file from Cloudinary when Resume is deleted
  def remove_file_from_cloudinary
    return unless file.present?

    begin
      Cloudinary::Uploader.destroy(file.public_id)
    rescue StandardError
      nil
    end
  end

  # Delete the old file before uploading a new one
  def remove_old_file_from_cloudinary
    return unless file.present? && file_changed?

    begin
      Cloudinary::Uploader.destroy(file.public_id)
    rescue StandardError
      nil
    end
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end

class Mobile < ApplicationRecord
  validates :service_slug, :encrypted_email, :encrypted_payload,
            :expires_at, :code, presence: true

  after_initialize :generate_code

  def mark_as_used
    update_attribute(:validity, 'used')
  end

  private

  def generate_code
    self.code ||= rand(89999) + 10000
  end
end

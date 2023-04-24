class SavedForm < ApplicationRecord
  self.implicit_order_column = 'created_at'
  validates :service_slug, presence: true

  def invalidated?
    return true if self.active == false
    return true if self.attempts >= 3
    return true if self.user_id.blank? || self.user_token.blank?
    false
  end

  def invalidate_user_fields!
    self.user_id = ""
    self.user_token = ""
    self.user_data_payload = ""
    self.secret_answer = ""
    self.active = false

    self.save!
  end

  def increment_attempts!
    self.attempts += 1

    self.save!
  end
end

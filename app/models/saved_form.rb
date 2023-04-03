class SavedForm < ApplicationRecord
  after_initialize :init
  self.implicit_order_column = 'created_at'
  validates :service_slug, presence: true
  validates :user_id, presence: true

  def init
    self.attempts ||= 0
    self.active ||= true
  end
end

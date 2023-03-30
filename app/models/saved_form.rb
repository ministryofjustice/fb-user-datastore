class SavedForm < ApplicationRecord
  self.implicit_order_column = 'created_at'
  validates :service_slug, presence: true
  validates :user_identifier, presence: true
end

class ChangeSavedFormsAttemptsToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :saved_forms, :attempts, :integer, default: 0
  end
end

class AddSecretQuestionTextToSavedForm < ActiveRecord::Migration[6.1]
  def change
    add_column :saved_forms, :secret_question_text, :string
  end
end

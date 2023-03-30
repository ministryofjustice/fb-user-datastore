class CreateSavedForms < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_forms, id: :uuid do |t|
      t.text :email
      t.text :secret_question
      t.text :secret_answer
      t.text :page_slug
      t.text :service_slug
      t.text :service_version
      t.text :user_id
      t.text :user_token
      t.text :user_data_payload
      t.numeric :attempts
      t.boolean :active

      t.timestamps
    end
  end
end

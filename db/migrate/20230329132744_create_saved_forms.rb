class CreateSavedForms < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_forms, id: :uuid do |t|
      t.string :email
      t.string :secret_question
      t.string :secret_answer
      t.string :page_slug
      t.string :service_slug
      t.string :service_version
      t.string :user_id
      t.string :user_token
      t.text :user_data_payload
      t.integer :attempts, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end

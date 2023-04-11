require 'modules/crypto'

FactoryBot.define do
  factory :saved_form do
    service_slug { 'my-service' }
    user_id { SecureRandom.uuid }
    user_token { SecureRandom.uuid }
    user_data_payload { Base64.encode64(
      Crypto::AES256.encrypt(
        key: 'abcdef0123456789', data: {'some_key' => 'some value'}.to_json
      )
    ) }
    page_slug { 'some_page/' }
    secret_question { 'bar' }
    secret_answer { 'foo' }
    email { 'email@email.com' }
    attempts { 0 }
    active { true }
    created_at { Time.current }
    updated_at { nil }
  end
end

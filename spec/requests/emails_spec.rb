require 'rails_helper'

RSpec.describe EmailsController, type: :request do
  let(:headers) do
    {
      'content-type' => 'application/json'
    }
  end

  let(:service_slug) { 'my-service' }

  describe 'POST /service/:service/savereturn/email/add' do
    let(:url) { "/service/#{service_slug}/savereturn/email/add" }

    let(:post_request) do
      post url, params: params.to_json, headers: headers
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:verify_token!)
    end

    context 'with a valid JSON body' do
      let(:params) do
        {
          email_for_sending: 'jane-doe@example.com',
          email_details: '64c0b8afa7e93d51c1fc5fe82cac4a690927ee1aa5883b985',
          duration: 30,
          link_template: {}
        }
      end

      context 'when the email record does not exist' do
        it 'returns a 201 status' do
          post_request
          expect(response).to have_http_status(201)
        end

        it 'sets validity to `valid`' do
          post_request
          expect(Email.first.validity).to eq('valid')
        end
      end

      context 'when the email record already exist' do
        let(:existing_record) do
          Email.create!(id: SecureRandom.uuid,
                        unique_id: '5db4f4e3-71ef-4784-a03a-2f2a490174f2',
                        email: 'jane-doe@example.com',
                        service_slug: service_slug,
                        encrypted_payload: '64c0b8afa7e93d51c1fc5fe82cac4a690927ee1aa5883b985',
                        expires_at: Time.now + 20.minutes,
                        validity: 'valid')
        end

        before do
          existing_record
          post_request
        end

        it 'there are two records with the same email address' do
          expect(Email.where(email: 'jane-doe@example.com').count).to eq(2)
        end

        it 'sets validity of existing record to `superseded`' do
          old_record = Email.find_by_unique_id(existing_record.unique_id)
          expect(old_record.validity).to eq('superseded')
        end

        it 'sets newest created record validity to `valid`' do
          new_record = Email.where.not(unique_id: existing_record.unique_id).first
          expect(new_record.validity).to eq('valid')
        end

        it 'returns a 201 status' do
          expect(response).to have_http_status(201)
        end
      end
    end
  end
end

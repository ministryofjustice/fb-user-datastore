require 'swagger_helper'
require 'securerandom'

RSpec.describe 'email confirmation' do
  before :each do
    allow_any_instance_of(ApplicationController).to receive(:disable_jwt?).and_return(true)
    stub_request(:post, "http://localhost:3000/save_return/email_confirmations").to_return(status: 201)
  end

  path '/service/{service_slug}/savereturn/email/add' do
    post 'send confirmation email to user' do
      consumes 'application/json'

      parameter name: :service_slug, in: :path, schema: {
        type: :string,
        required: true
      }

      parameter name: :json, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          encrypted_email: { type: :string, example: 'encrypted:user@example.com' },
          encrypted_details: { type: :string, example: 'encrypted:payload' },
          duration: { type: :integer, required: false, default: 120, example: 120 },
        }
      }

      response '201', 'email confirmation created' do
        let(:service_slug) { 'service-slug' }
        let(:json) do
          {
            email: 'user@example.com',
            encrypted_email: 'encrypted:user@example.com',
            encrypted_details: 'encrypted:payload'
          }
        end

        run_test!
      end
    end
  end

  path '/service/{service_slug}/savereturn/email/confirm' do
    post 'confirm email from magiclink' do
      consumes 'application/json'

      parameter name: :service_slug, in: :path, schema: {
        type: :string,
        required: true
      }

      parameter name: :json, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email_token: { type: :string, required: true, example: SecureRandom.uuid },
        },
      }

      response '200', 'magiclink correct and processed' do
        let(:uuid) { SecureRandom.uuid }
        let(:service_slug) { 'service-slug' }
        let(:json) do
          {
            email: 'user@example.com',
            email_token: uuid
          }
        end

        before :each do
          Email.create(id: uuid,
                       encrypted_payload: 'foo',
                       service_slug: 'foo',
                       email: 'foo',
                       expires_at: 1.hour.from_now,
                       encrypted_email: 'foo')
        end

        run_test!
      end

      response '404', 'magic link not found' do
        let(:service_slug) { 'service-slug' }
        let(:json) do
          {
            email: 'user@example.com',
            encrypted_email: 'encrypted:user@example.com',
            encrypted_details: 'encrypted:payload'
          }
        end

        run_test!
      end

      response '410', 'magiclink already used or expired' do
        let(:uuid) { SecureRandom.uuid }
        let(:service_slug) { 'service-slug' }
        let(:json) do
          {
            email: 'user@example.com',
            email_token: uuid
          }
        end

        before :each do
          Email.create(id: uuid,
                       encrypted_payload: 'foo',
                       service_slug: 'foo',
                       email: 'foo',
                       expires_at: 2.days.ago,
                       encrypted_email: 'foo')
        end

        run_test!
      end

      response '400', 'magiclink superseded' do
        let(:uuid) { SecureRandom.uuid }
        let(:service_slug) { 'service-slug' }
        let(:json) do
          {
            email: 'user@example.com',
            email_token: uuid
          }
        end

        before :each do
          Email.create(id: uuid,
                       encrypted_payload: 'foo',
                       service_slug: 'foo',
                       email: 'foo',
                       expires_at: 2.days.from_now,
                       encrypted_email: 'foo',
                       validity: 'superseded')
        end

        run_test!
      end
    end
  end
end
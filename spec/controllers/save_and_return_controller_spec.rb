require 'rails_helper'

RSpec.describe SaveAndReturnController, type: :controller do
  before :each do
    allow_any_instance_of(ApplicationController).to receive(:verify_token!)
    request.env['CONTENT_TYPE'] = 'application/json'
  end

  let(:json_hash) do
    {
      errors: {},
      email: "email@email.com",
      page_slug: "page-slug",
      secret_question: "some text",
      secret_answer: "some more text",
      service_slug: "some-slug",
      service_version: "27dc30c9-f7b8-4dec-973a-bd153f6797df",
      user_id: "8acfb3db90002a5fc5b43e71638fc709",
      user_token: "b9cca34d4331399c5f461c0ba1c406aa",
      secret_question_text: "some text",
      user_data_payload: {
        name_text_1: "Name"
      },
      validation_context: "null"
    }
  end

  describe 'GET #show' do
    before do
      post :create, params: { service_slug: 'some-slug' },
                        body: json_hash.to_json
    end

    it 'gets the form' do
      uuid = SavedForm.first.id

      get :show, params: { service_slug: 'service-slug', uuid: uuid }
      expect(response.status).to be(200)
      expect(response.body).to include(json_hash[:email])
      expect(response.body).to include(json_hash[:secret_answer])
      expect(response.body).to include(json_hash[:secret_question])
      expect(response.body).to include(json_hash[:secret_question_text])
      expect(response.body).to include(json_hash[:user_id])
      expect(response.body).to include(json_hash[:user_token])
      expect(response.body).to include(json_hash[:service_slug])
      expect(response.body).to include(json_hash[:service_version])
      expect(response.body).to include(json_hash[:page_slug])
    end

    describe 'when not found' do
      it 'returns 404' do
        get :show, params: { service_slug: 'some-slug', uuid: 'i-am-an-id-that-does-not-exist' }, body: {}.to_json

        expect(response.status).to eql(404)
      end
    end

    describe 'when record has been invalidated' do
      it 'returns 422' do
        uuid = SavedForm.first.id
        SavedForm.first.invalidate_user_fields!

        get :show, params: { service_slug: 'some-slug', uuid: uuid }, body: {}.to_json

        expect(response.status).to eql(422)
      end

      it 'returns 400 if too many attemtps' do
        uuid = SavedForm.first.id
        3.times do
          SavedForm.first.increment_attempts!
        end

        get :show, params: { service_slug: 'some-slug', uuid: uuid }, body: {}.to_json

        expect(response.status).to eql(400)
      end
    end
  end

  describe 'UPDATE #invalidate' do
  before do
    post :create, params: { service_slug: 'some-slug' },
                      body: json_hash.to_json
  end

    describe 'record is valid' do
      it 'should invalidate the record' do
        uuid = SavedForm.first.id

        post :invalidate, params: { service_slug: 'some-slug', uuid: uuid }, body: {}.to_json

        expect(SavedForm.first.invalidated?).to eql(true)
      end

      it 'should return 202 accepted' do
        uuid = SavedForm.first.id

        post :invalidate, params: { service_slug: 'some-slug', uuid: uuid }, body: {}.to_json

        expect(response.status).to eql(202)
      end
    end

    describe 'record cannot be invalidated' do
      describe 'record does not exist' do
        it 'should return 404' do
          post :invalidate, params: { service_slug: 'some-slug', uuid: 'i-do-not-exist' }, body: {}.to_json
          
          expect(response.status).to eql(404)
        end
      end

      describe 'record already invalid' do
        it 'should return 422' do
          uuid = SavedForm.first.id
          SavedForm.first.invalidate_user_fields!
  
          post :invalidate, params: { service_slug: 'some-slug', uuid: uuid }, body: {}.to_json
  
          expect(response.status).to eql(422)
        end
      end
    end
  end

  describe 'UPDATE #increment' do
    before do
      post :create, params: { service_slug: 'some-slug' },
                        body: json_hash.to_json
    end

    describe 'happy path' do
      it 'should increment the attempts count' do
        uuid = SavedForm.first.id

        post :increment, params: { service_slug: 'some-slug', uuid: uuid }

        expect(SavedForm.first.attempts).to eql(1)
        expect(SavedForm.first.invalidated?).to eql(false)
      end

      it 'should return ok' do
        uuid = SavedForm.first.id

        post :increment, params: { service_slug: 'some-slug', uuid: uuid }

        expect(response.status).to eql(200)
      end
    end

    describe 'record does not exist' do
      it 'should return not found' do
        post :increment, params: { service_slug: 'some-slug', uuid: 'does-not-exist' }

        expect(response.status).to eql(404)
      end
    end

    describe 'record is invalid' do
      it 'should return unprocessable if too many attempts' do
        uuid = SavedForm.first.id

        3.times do
           SavedForm.first.increment_attempts!
        end

        post :increment, params: { service_slug: 'some-slug', uuid: uuid }

        expect(response.status).to eql(422)
      end

      it 'should return unprocessable if invalidated' do
        uuid = SavedForm.first.id

        SavedForm.first.invalidate_user_fields!

        post :increment, params: { service_slug: 'some-slug', uuid: uuid }

        expect(response.status).to eql(422)
      end
    end
  end

  describe 'POST #create' do
    let(:json_hash) do
      {
        errors: {},
        email: "email@email.com",
        page_slug: "page-slug",
        secret_question: "some text",
        secret_answer: "some more text",
        service_slug: "some-slug",
        service_version: "27dc30c9-f7b8-4dec-973a-bd153f6797df",
        user_id: "8acfb3db90002a5fc5b43e71638fc709",
        user_token: "b9cca34d4331399c5f461c0ba1c406aa",
        user_data_payload: {
          name_text_1: "Name"
        },
        validation_context: "null"
      }
    end

    describe 'happy path' do
      it 'creates record' do
        expect do
          post :create, params: { service_slug: 'some-slug' },
                        body: json_hash.to_json

        end.to change(SavedForm, :count).by(1)
      end

      it 'returns 201 with created uuid' do
        post :create, params: { service_slug: 'some-slug' },
                      body: json_hash.to_json
        expect(response.status).to eql(201)

        expected_generated_id = SavedForm.last.id
        expect(response.body).to eql({ id: expected_generated_id}.to_json)
      end
    end
  
    describe 'when cant save record' do
      it 'returns 500' do
        allow_any_instance_of(SavedForm).to receive(:save).and_return(false)

        post :create, params: { service_slug: 'service-slug' },
                      body: json_hash.to_json

        expect(response.status).to eql(500)
      end
    end
  end
end

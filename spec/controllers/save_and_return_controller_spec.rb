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
    end

    describe 'when not found' do
      it 'returns 404' do
        get :show, params: { service_slug: 'some-slug', uuid: 'i-am-an-id-that-does-not-exist' }, body: {}.to_json

        expect(response.status).to eql(404)
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
        allow_any_instance_of(SavedForm).to receive(:save!).and_return(false)

        post :create, params: { service_slug: 'service-slug' },
                      body: json_hash.to_json

        expect(response.status).to eql(500)
      end
    end

    describe 'when bad request' do
      it 'returns 402' do
        allow(SavedForm).to receive(:create).and_return(false)

        post :create, params: { service_slug: 'service-slug' },
                      body: {}.to_json

        expect(response.status).to eql(400)
      end
    end
  end
end

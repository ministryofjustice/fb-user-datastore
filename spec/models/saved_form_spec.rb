require 'rails_helper'

RSpec.describe SavedForm, type: :model do
  it { should validate_presence_of(:service_slug) }

  it 'should set the default values' do
    expect(subject.attempts).to eq(0)
    expect(subject.active).to eq(true)
  end

  describe '#invalidated' do
    let(:model) { SavedForm.new(user_id: '123', user_token: '456', user_data_payload: 'q1 => answer', secret_answer: 'hello', active: true, service_slug: 'some_slug') }
    
    context 'user id is empty' do
      it 'should consider the model invalidated' do
        expect(model.invalidated?).to be(false)
        model.user_id = nil
        expect(model.invalidated?).to be(true)
        model.user_id = ""
        expect(model.invalidated?).to be(true)
      end
    end

    context 'user token is empty' do
      it 'should consider the model invalidated' do
        expect(model.invalidated?).to be(false)
        model.user_token = nil
        expect(model.invalidated?).to be(true)
        model.user_token = ""
        expect(model.invalidated?).to be(true)
      end
    end

    context 'attempts above max limit (3)' do
      it 'should consider the model invalidated' do
        expect(model.invalidated?).to be(false)
        model.increment_attempts!
        expect(model.invalidated?).to be(false)
        model.increment_attempts!
        expect(model.invalidated?).to be(false)
        model.increment_attempts!
        expect(model.invalidated?).to be(false)
        model.increment_attempts!
        expect(model.invalidated?).to be(true)
      end
    end

    context 'record marked inactive' do
      it 'should consider the model invalidated' do
        expect(model.invalidated?).to be(false)
        model.active = false
        expect(model.invalidated?).to be(true)
      end
    end
  end

  describe '#invalidate_user_fields' do
    let(:model) { SavedForm.new(user_id: '123', user_token: '456', user_data_payload: 'q1 => answer', secret_answer: 'hello', active: true, service_slug: 'some_slug') }

    it 'should remove sensitive data and invalidate the record' do
      model.invalidate_user_fields!

      expect(model.user_id.blank?).to be(true)
      expect(model.user_token.blank?).to be(true)
      expect(model.user_data_payload.blank?).to be(true)
      expect(model.secret_answer.blank?).to be(true)
      expect(model.active).to be(false)

      expect(model.invalidated?).to be(true)
    end
  end
end

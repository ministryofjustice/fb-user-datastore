require 'rails_helper'

RSpec.describe DbSweeper do
  describe '#call UserData' do
    context 'when there is user data over 28 days old' do
      before :each do
        create(:user_data, created_at: 30.days.ago)
        create(:user_data, created_at: 5.days.ago)
      end

      it 'destroys the older records' do
        expect do
          subject.call
        end.to change(UserData, :count).by(-1)
      end
    end

    context 'when there is no user data over 28 days old' do
      before :each do
        create(:user_data, created_at: 5.days.ago)
      end

      it 'leaves records intact' do
        expect do
          subject.call
        end.to_not change(UserData, :count)
      end
    end
  end

  describe '#call SavedProgress' do
    context 'when there is saved progress data over 60 days old' do
      before :each do
        create(:saved_form, created_at: 61.days.ago)
        create(:saved_form, created_at: 5.days.ago)
      end

      it 'destroys the older records' do
        expect do
          subject.call
        end.to change(SavedForm, :count).by(-1)
      end
    end

    context 'when there is no saved progress over 60 days old' do
      before :each do
        create(:saved_form, created_at: 59.days.ago)
      end

      it 'leaves records intact' do
        expect do
          subject.call
        end.to_not change(SavedForm, :count)
      end
    end

    context 'invalidating the user data' do
      before :each do
        create(:saved_form, created_at: 39.days.ago)
        create(:saved_form, created_at: 27.days.ago)
      end

      it 'removes all user data from records over 28 days old' do
        subject.call

        still_valid = SavedForm.where("created_at > ?", 28.days.ago)
        expect(still_valid.count).to be(1)
        expect(still_valid.first.invalidated?).to be(false)

        invalid = SavedForm.where("created_at < ?", 28.days.ago)
        expect(invalid.count).to be(1)
        expect(invalid.first.invalidated?).to be(true)
        expect(invalid.first.user_token.blank?).to be(true)
      end

      it 'leaves records intact' do
        expect do
          subject.call
        end.to_not change(SavedForm, :count)
      end
    end
  end
end

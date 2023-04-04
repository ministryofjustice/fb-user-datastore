require 'rails_helper'

RSpec.describe SavedForm, type: :model do
  it { should validate_presence_of(:service_slug) }
  it { should validate_presence_of(:user_id) }

  it 'should set the default values' do
    expect(subject.attempts).to eq(0)
    expect(subject.active).to eq(true)
  end
end

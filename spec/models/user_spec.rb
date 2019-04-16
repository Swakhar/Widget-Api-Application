require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create :user, email: 'swakhar.me@gmail.com' }

  it { is_expected.to validate_presence_of :firstname }
  it { is_expected.to validate_presence_of :lastname }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_uniqueness_of :username }
  it { is_expected.to have_many :widgets }

  describe '.can_sign_in' do
    context 'when password matches with existing user' do
      it 'returns user' do
        expect(described_class.can_sign_in('swakhar.me@gmail.com', 'swakhar')).to eq user
      end
    end

    context 'when password does not match with existing user' do
      it 'returns nil' do
        expect(described_class.can_sign_in('swakhar.me@gmail.com', 'password')).to eq nil
      end
    end
  end
end

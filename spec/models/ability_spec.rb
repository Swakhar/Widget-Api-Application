require 'rails_helper'

RSpec.describe Ability, type: :model do
  let!(:user) { FactoryBot.create :user, email: 'swakhar.me@gmail.com', username: 'swakhar' }
  let!(:another_user) { FactoryBot.create :user, email: 'atique.rahman@gmail.com', username: 'atique' }
  let!(:first_user_widget) { FactoryBot.create :widget, user: user, name: 'Widget 1' }
  let!(:another_user_widget) { FactoryBot.create :widget, user: another_user, name: 'Widget 2' }

  let(:instance) { Ability.new user }

  subject { instance }
  describe 'User' do
    it { is_expected.to be_able_to(:read, user) }
    it { is_expected.to be_able_to(:read, another_user) }
    it { is_expected.to be_able_to(:update, user) }
    it { is_expected.to_not be_able_to(:update, another_user) }
    it { is_expected.to be_able_to(:destroy, user) }
    it { is_expected.to_not be_able_to(:destroy, another_user) }
  end

  describe 'Widget' do
    it { is_expected.to be_able_to(:read, first_user_widget) }
    it { is_expected.to be_able_to(:read, another_user_widget) }
    it { is_expected.to be_able_to(:update, first_user_widget) }
    it { is_expected.to_not be_able_to(:update, another_user_widget) }
    it { is_expected.to be_able_to(:destroy, first_user_widget) }
    it { is_expected.to_not be_able_to(:destroy, another_user_widget) }
  end
end

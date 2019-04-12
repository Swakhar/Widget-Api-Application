require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:user) { FactoryBot.create :user }
  let!(:widget) { FactoryBot.create :widget, user: user }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :kind }
  it { is_expected.to validate_inclusion_of(:kind).in_array(%w(visible hidden)) }

  it { is_expected.to belong_to :user }
end

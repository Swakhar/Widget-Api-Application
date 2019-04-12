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

  describe '.visible' do
    context 'for visible widgets' do
      it 'returns array of visible widgets' do
        expect(described_class.visible).to eq [widget]
      end
    end

    context 'for hidden widgets' do
      before do
        widget.update kind: 'hidden'
      end
      it 'returns empty array' do
        expect(described_class.visible).to eq []
      end
    end
  end
end

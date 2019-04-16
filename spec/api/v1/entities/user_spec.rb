require 'rails_helper'

RSpec.describe API::V1::Entities::User do
  let!(:user) { FactoryBot.create(:user, email: 'swakhar.me@gmail.com') }
  let(:user_entity) { API::V1::Entities::User.represent(user) }
  subject { JSON.parse(user_entity.to_json) }
  let(:expected_hash) do
    {
      'id' => user.id,
      'firstname' => 'Swakhar',
      'lastname' => 'Dey',
      'email' => 'swakhar.me@gmail.com',
      'username' => 'swakhar-dey'
    }
  end

  it 'matches the api specification' do
    expect(subject).to eq expected_hash
  end
end

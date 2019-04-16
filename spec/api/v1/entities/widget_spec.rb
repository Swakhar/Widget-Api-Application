require 'rails_helper'

RSpec.describe API::V1::Entities::Widget do
  let!(:user) { FactoryBot.create(:user, email: 'swakhar.me@gmail.com') }
  let!(:widget) { FactoryBot.create :widget, user: user }
  let(:widget_entity) { API::V1::Entities::Widget.represent(widget) }
  subject { JSON.parse(widget_entity.to_json) }
  let(:expected_hash) do
    {
        'id' => widget.id,
        'name' => 'Widget 1',
        'description' => 'Widget description',
        'kind' => 'visible',
        'user' => {
            'id' => user.id,
            'email' => user.email,
            'username' => user.username,
            'firstname' => user.firstname,
            'lastname' => user.lastname,
        }
    }
  end

  it 'matches the api specification' do
    expect(subject).to eq expected_hash
  end
end

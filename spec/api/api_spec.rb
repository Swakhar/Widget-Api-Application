require 'rails_helper'

RSpec.describe API do
  let!(:user) { FactoryBot.create(:user) }
  let(:wrong_endpoint) { '/api/v1/wrong_endpoint' }
  let(:valid_token) do
    access_token = generate_access_token_for(user)
    {
        access_token: access_token
    }
  end

  it 'returns 404 on invalid endpoint' do
    get wrong_endpoint, params: valid_token
    expect(response.status).to eq 404
  end
end

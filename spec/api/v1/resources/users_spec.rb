require 'rails_helper'

RSpec.describe API::V1::Resources::Users do
  let!(:application) do
    Doorkeeper::Application.create! name: 'Widget API', redirect_uri: 'https://www.showoff.ie/'
  end
  let!(:user) { FactoryBot.create(:user, email: 'swakhar.me@gmail.com') }
  let(:response_json) { JSON.parse(response.body) }
  let(:user_entity) { API::V1::Entities::User.represent(user) }

  describe 'Get /users/me' do
    let(:request_url) { '/api/v1/users/me' }
    let(:valid_token) do
      {
        access_token: generate_access_token_for(user)
      }
    end
    it 'returns a hash of current user profile' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq(JSON.parse(user_entity.to_json))
    end
  end

  describe 'Get /users/:id' do
    let!(:another_user) { FactoryBot.create :user, username: 'atique' }
    let(:request_url) { "/api/v1/users/#{another_user.id}" }
    let(:another_user_entity) { API::V1::Entities::User.represent(another_user) }
    let(:valid_token) do
      {
        access_token: generate_access_token_for(user)
      }
    end
    it 'returns a hash of params user profile' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq(JSON.parse(another_user_entity.to_json))
    end
  end

  describe 'Get /users/email' do
    let(:request_url) { '/api/v1/users/email' }
    let(:params) do
      {
        email: 'swakhar.me@gmail.com',
        client_id: application.uid,
        client_secret: application.secret
      }
    end
    it 'returns availablity of the user' do
      get request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq({ 'available' => true })
    end
  end

  describe 'Post /users' do
    let(:request_url) { '/api/v1/users' }
    let(:params) do
      {
          user: {
            email: 'swakhar1.me@gmail.com',
            password: '123456',
            username: 'swakhs'
          },
          client_id: application.uid,
          client_secret: application.secret
      }
    end
    it 'creates a new user' do
      post request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(201)
      expect(User.count).to eq 2
    end
  end

  describe 'Put /users/me' do
    let(:request_url) { '/api/v1/users/me' }
    let(:params) do
      {
          user: {
              username: 'swakhs'
          },
          access_token: generate_access_token_for(user)
      }
    end
    it 'updates existing user' do
      put request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(user.reload.username).to eq('swakhs')
    end
  end

  describe 'Post /users/me/password' do
    let(:request_url) { '/api/v1/users/me/password' }
    let(:params) do
      {
          user: {
              current_password: 'swakhar',
              new_password: 'swakhar',
          },
          access_token: generate_access_token_for(user)
      }
    end
    it 'update password of existing user' do
      post request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(201)
      expect(user.reload.password).to eq('swakhar')
    end
  end

  describe 'Post /users/reset_password' do
    let(:request_url) { '/api/v1/users/reset_password' }
    let(:params) do
      {
          user: {
              email: 'swakhar.me@gmail.com'
          },
          client_id: application.uid,
          client_secret: application.secret,
      }
    end
    it 'reset password of existing user' do
      post request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(201)
      expect(user.reload.password.length).to eq 7
    end
  end

  describe 'Get /users/me/widgets' do
    let(:request_url) { '/api/v1/users/me/widgets' }
    let!(:widget) { FactoryBot.create :widget, user: user }
    let(:widget_entity) { API::V1::Entities::Widget.represent(widget) }
    let(:valid_token) do
      {
        access_token: generate_access_token_for(user)
      }
    end
    it 'returns all visible widgets of current user' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq([JSON.parse(widget_entity.to_json)])
    end
  end

  describe 'Get /users/:id/widgets' do
    let!(:another_user) { FactoryBot.create :user, email: 'atique.rahman@gmail.com', username: 'atique' }
    let(:request_url) { "/api/v1/users/#{another_user.id}/widgets" }
    let!(:widget) { FactoryBot.create :widget, user: another_user }
    let(:widget_entity) { API::V1::Entities::Widget.represent(widget) }
    let(:valid_token) do
      {
          access_token: generate_access_token_for(user)
      }
    end
    it 'returns all visible widgets of current user' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq([JSON.parse(widget_entity.to_json)])
    end
  end
end

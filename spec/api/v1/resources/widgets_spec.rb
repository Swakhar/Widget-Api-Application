require 'rails_helper'

RSpec.describe API::V1::Resources::Widgets do
  let!(:user) { FactoryBot.create(:user, email: 'swakhar.me@gmail.com') }
  let!(:widget) { FactoryBot.create :widget, user: user }
  let(:response_json) { JSON.parse(response.body) }
  let(:widget_entity) { API::V1::Entities::Widget.represent(widget) }

  describe 'Get /widgets' do
    let(:request_url) { '/api/v1/widgets' }
    let(:valid_token) do
      {
          access_token: generate_access_token_for(user)
      }
    end
    it 'returns all widgets' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq([JSON.parse(widget_entity.to_json)])
    end
  end

  describe 'Get /widgets/visible' do
    let(:request_url) { '/api/v1/widgets/visible' }
    let(:valid_token) do
      {
          access_token: generate_access_token_for(user)
      }
    end
    it 'returns all visible widgets' do
      get request_url, params: valid_token
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response_json).to eq([JSON.parse(widget_entity.to_json)])
    end
  end

  describe 'Post /widgets' do
    let(:request_url) { '/api/v1/widgets' }
    let(:params) do
      {
          widget: {
              name: 'Widget 2',
              description: 'Widget Description',
              kind: 'visible',
          },
          access_token: generate_access_token_for(user)
      }
    end
    it 'creates a new widget' do
      post request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(201)
      expect(Widget.count).to eq 2
    end
  end

  describe 'Put /widgets/:id' do
    let(:request_url) { "/api/v1/widgets/#{widget.id}" }
    let(:params) do
      {
          widget: {
              name: 'Widget 2',
              description: 'Widget Description',
          },
          access_token: generate_access_token_for(user)
      }
    end
    it 'creates a new widget' do
      put request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(widget.reload.name).to eq 'Widget 2'
    end
  end

  describe 'Delete /widgets/:id' do
    let(:request_url) { "/api/v1/widgets/#{widget.id}" }
    let(:params) do
      {
          access_token: generate_access_token_for(user)
      }
    end
    it 'creates a new widget' do
      delete request_url, params: params
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(Widget.count).to eq 0
    end
  end
end

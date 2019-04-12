require 'rails_helper'

RSpec.describe ResetPasswordMailer, type: :mailer do
  describe '#reset_password' do
    let(:user) { FactoryBot.create(:user, email: 'swakhar.me@gmail.com') }
    let(:mail) { ResetPasswordMailer.reset_password(user.email, '123456') }

    it 'renders the subject' do
      expect(mail.subject).to eq('New password for widget api application')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@showoff.com'])
    end

    it 'renders the message body' do
      expect(mail.body).not_to be_nil
    end
  end
end

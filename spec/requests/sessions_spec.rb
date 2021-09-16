# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  context 'when user not registered' do
    it 'signs user up' do
      get root_url
      expect(response).to render_template(:home)
      expect(response.body).to include('Login')

      user = build(:user)
      post user_registration_path, params: {
        'user[email]': user.email,
        'user[password]': user.password,
        'user[password_confirmation]': user.password
      }

      expect(response).to redirect_to(root_url)
      follow_redirect!

      expect(response).to render_template(:todos)
      expect(response.body).to include('Logout')
    end
  end

  context 'when user registered' do
    it 'signs user in and out' do
      user = create(:user)
      sign_in user
      get root_path
      expect(response).to render_template(:todos)
      expect(response.body).to include('Logout')

      sign_out user
      get root_path
      expect(response).not_to render_template(:todos)
      expect(response.body).to include('Login')
    end
  end
end


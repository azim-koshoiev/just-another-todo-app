# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      password: 'password',
      email: 'test@test.com'
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a password' do
      subject.password = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid with password less than 6 characters' do
      subject.password = '12345'
      expect(subject).to_not be_valid
    end

    it 'is not valid without email' do
      subject.email = ''
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate email address' do
      User.create do |u|
        u.email = 'test@test.com'
        u.password = 'password'
      end
      subject.valid?
      expect(subject.errors[:email]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
  end
end

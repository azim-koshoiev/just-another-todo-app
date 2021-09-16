# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject do
    described_class.new(
      title: 'not blank',
      user: User.new
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without title' do
    subject.title = ''
    expect(subject).to_not be_valid
  end

  it 'is not valid without user' do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:todos).dependent(:destroy) }
  end
end

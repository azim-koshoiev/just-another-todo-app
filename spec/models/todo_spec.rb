# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  subject do
    described_class.new(
      title: 'not blank',
      project: Project.new
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without title' do
    subject.title = ''
    expect(subject).to_not be_valid
  end

  it 'is not valid without project' do
    subject.project = nil
    expect(subject).to_not be_valid
  end

  describe 'associations' do
    it { should belong_to(:project) }
  end
end

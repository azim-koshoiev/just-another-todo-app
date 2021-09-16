# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { Faker::Lorem.word }
    user
  end
end

def user_with_projects(projects_count: 1)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:project, projects_count, user: user)
  end
end

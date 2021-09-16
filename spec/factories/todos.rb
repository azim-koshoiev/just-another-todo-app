# frozen_string_literal

FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    project
  end
end

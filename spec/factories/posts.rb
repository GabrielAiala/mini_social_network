FactoryBot.define do
  factory :post do
    association :user
    content { "MyText" }
  end
end

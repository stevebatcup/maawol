FactoryBot.define do
  factory :user do
  	email { "foo@bar.com" }
  	first_name { "Steve" }
  	last_name { "Chunkup" }
  end
end
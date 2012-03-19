FactoryGirl.define do
  factory :user do
    sequence(:username) { |u| "user#{u}" }
    sequence(:email) { |e| "email#{e}@email.com" }
    #email 'lkjsdf@lkdjf.com'
    password 'jjjjjj'
    password_confirmation 'jjjjjj'
  end
end

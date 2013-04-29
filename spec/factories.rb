FactoryGirl.define do 
  factory :todolist do
    sequence(:title) { |n| "todolist's title #{n}" }
    public false
    user
  end

  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "secretpass"
    password_confirmation { |p| p.password }

    factory :user_with_todolists do

      ignore do
        lists_count 3
      end
     
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:todolist, evaluator.lists_count, user: user)
      end
    end
  end

end


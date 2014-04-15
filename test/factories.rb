FactoryGirl.define do
  factory :domain do
    name "Software"
    active true
  end
  
  factory :user do
    first_name "Ed"
    last_name "Gruberman"
    password "secret"
    password_confirmation "secret"
    email { |u| "#{u.first_name[0]}#{u.last_name}#{(1..99).to_a.sample}@example.com".downcase }
    role "member"
    active true
  end
  
  factory :project do
    association :domain
    association :manager, factory: :user
    start_date 10.weeks.ago.to_date
    end_date 1.day.ago.to_date
    name "Arbeit"
    description "A most glorious project that will bring fame and honor to all those who are associated with it.  This project will also be a rich blessing to all who use it properly."
  end
  
  factory :task do
    name "Data modeling"
    due_on 1.day.ago
    due_string "yesterday"
    association :project
    association :creator, factory: :user
    association :completer, factory: :user
    completed true
    priority 1
  end
  
  factory :assignment do
    association :project
    association :user
    active true
  end
end
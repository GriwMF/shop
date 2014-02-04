# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    number Faker::Number.number(16)
    cvv "123"
    expiration_month 12
    expiration_year 2016
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    customer
  end
end

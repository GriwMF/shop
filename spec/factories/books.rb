# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "War and Peace"
    descirption "bla bla bla" 
    price 5
    in_stock 3
  end
end

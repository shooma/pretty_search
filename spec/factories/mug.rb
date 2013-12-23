# encoding: utf-8
FactoryGirl.define do
  factory :mug do
    sequence(:volume) { |n| n }
  end
end
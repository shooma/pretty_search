# encoding: utf-8
FactoryGirl.define do
  factory :company do
    sequence(:title) { |n| "title_#{n}"}
  end
end
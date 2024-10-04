FactoryBot.define do
  factory :role do
    name { Faker::Superhero.unique.name}
  end
end

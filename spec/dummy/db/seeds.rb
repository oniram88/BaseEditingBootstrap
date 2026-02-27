if Role.count < 10
  10.times do
    Role.create!(
      name: Faker::Superhero.unique.name
    )
  end
end

if User.count < 10

  10.times do
    u = User.create!(
      username: Faker::Internet.unique.username
    )
    u.roles << Role.all.sample

    5.times do
      Post.create!(
        title: Faker::Book.title,
        user: u,
        description: Faker::Lorem.paragraphs(number: 4).join("\n\n"),
        category: Post.categories.keys.sample
      )
    end

  end

end

if Company.count < 10

  10.times do
    Company.create!(
      name: Faker::Company.unique.name,
      addresses_attributes: [
        {
          street: Faker::Address.unique.street_name,
          cap: Faker::Address.unique.zip,
          city: Faker::Address.unique.city,
        },
        {
          street: Faker::Address.unique.street_name,
          cap: Faker::Address.unique.zip,
          city: Faker::Address.unique.city,
        }
      ],
      shipping_addresses_attributes: [
        {
          street: Faker::Address.unique.street_name,
          cap: Faker::Address.unique.zip,
          city: Faker::Address.unique.city,
        },
        {
          street: Faker::Address.unique.street_name,
          cap: Faker::Address.unique.zip,
          city: Faker::Address.unique.city,
        }
      ]
    )

  end

end





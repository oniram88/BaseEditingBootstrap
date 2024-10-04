if Post.count < 25
  30.times do
    Post.create!(
      title: Faker::Book.title,
      description: Faker::Lorem.paragraphs(number: 4).join("\n\n"),
      category: Post.categories.keys.sample
    )
  end
end

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
  end

end
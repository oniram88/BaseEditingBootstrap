if Post.count < 25
  30.times do
    Post.create!(
      title: Faker::Book.title,
      description: Faker::Lorem.paragraphs(number: 4).join("\n\n"),
      category: Post.categories.keys.sample
    )
  end
end
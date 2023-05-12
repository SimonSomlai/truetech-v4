require 'faker'
require 'open-uri'

User.create!(
  name: "Simon",
  email: "simon_somlai@hotmail.com",
  password: "password",
  password_confirmation: "password",
  remote_profile_picture_url: Faker::LoremFlickr.image,
admin: true)

20.times do |n|
  title = Faker::Book.title
  description = Faker::Lorem.paragraph(sentence_count: 2)
  skills = Faker::Lorem.paragraph(sentence_count: 1)
  link = Faker::Internet.url
  user_id = User.find_by(name: "Simon").id
  service = ["starters website", "webapplicatie", "single page", "website op maat"].sample
  project = Project.create!(
  follow_up: true,
    title: title,
    description: description,
    user_id: user_id,
    service: service.gsub(/_/, ' '),
    skills: skills,
  link: link)

  project.tags.create!(
    name: title,
    icon: "react.png"
  )
end

Project.all.each do |project|
  url = [Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image].sample
  file = URI.open(url)
  project.project_images.attach(io: file, filename: project.title)
end

5.times do |n|
  name = Faker::Name.name
  quote = Faker::Lorem.paragraph
  company = Faker::Company.name
  link = Faker::Internet.url
  url = [Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image].sample
  Testimonial.create!(
    name: name,
    quote: quote,
    company: company,
    remote_image_url: url,
  link: link)
end

5.times do |n|
  title = Faker::Book.title
  description = Faker::Lorem.paragraph(sentence_count: 2)
  body = Faker::Lorem.paragraph(sentence_count: 15)
  category = ["business", "technology"].sample
  user_id = User.find_by(name: "Simon").id
  url = [Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image].sample
  article = Article.create!(
    title: title,
    description: description,
    body: body,
    slug_en: title.parameterize + "-english",
    slug_nl: title.parameterize + "-dutch",
    category: category,
    posted: true,
    user_id: User.first.id)

    file = URI.open(url)
    article.image.attach(io: file, filename: title)
end


5.times do |n|
  en_title = Faker::Book.title
  en_description = Faker::Lorem.paragraph(sentence_count: 2)
  en_body =  Faker::Lorem.paragraph(sentence_count: 15)
  category = ["coding","business", "technology"].sample
  user_id = User.find_by(name: "Simon").id
  url = [Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image, Faker::LoremFlickr.image].sample
  article = Article.create!(
    slug_en: en_title.parameterize + "-english",
    en_title: en_title,
    en_description: en_description,
    en_body: en_body,
    category: category,
    posted: true,
    user_id: User.first.id,
    title: ""
  )
    

    file = URI.open(url)
    article.image.attach(io: file, filename: en_title)
end

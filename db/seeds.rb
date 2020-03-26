User.create!(
  name: "Simon",
  email: "simon_somlai@hotmail.com",
  password: "password",
  password_confirmation: "password",
  remote_profile_picture_url: "http://i1.wp.com/www.basicgrowth.com/wp-content/uploads/2013/09/Profiler5.jpg",
admin: true)

20.times do |n|
  title = Faker::Book.title
  description = Faker::Lorem.paragraph(2)
  skills = Faker::Lorem.paragraph(1)
  link = Faker::Internet.url
  features = "none=>none"
  user_id = User.find_by(name: "Simon").id
  service = ["starters website", "webapplicatie", "single page", "website op maat"].sample
  Project.create!(
  follow_up: true,
    title: title,
    description: description,
    features: features,
    user_id: user_id,
    service: service.gsub(/_/, ' '),
    skills: skills,
  link: link)
end

Project.all.each do |project|
  url = ["http://basicgrowth.com/files/seed/portfolio1.jpg", "http://basicgrowth.com/files/seed/portfolio2.jpg", "http://basicgrowth.com/files/seed/portfolio3.jpg", "http://basicgrowth.com/files/seed/portfolio4.jpg"].sample
  ProjectImage.create!(
    remote_images_url: url.gsub(/_/, ' '),
    project_id: project.id
  )
end

5.times do |n|
  name = Faker::Name.name
  quote = Faker::Lorem.paragraph(3)
  company = Faker::Company.name
  link = Faker::Internet.url
  url = ["http://basicgrowth.com/files/seed/person1.jpg", "http://basicgrowth.com/files/seed/person2.jpg", "http://basicgrowth.com/files/seed/person3.jpg", "http://basicgrowth.com/files/seed/person4.jpg"].sample
  Testimonial.create!(
    name: name,
    quote: quote,
    company: company,
    remote_image_url: url,
  link: link)
end

5.times do |n|
  title = Faker::Book.title
  description = Faker::Lorem.paragraph(2)
  body = Faker::Lorem.paragraph(15)
  en_title = title + " English"
  en_description = Faker::Lorem.paragraph(2)
  en_body = Faker::Lorem.paragraph(15)
  category = ["business", "technology"].sample
  user_id = User.find_by(name: "Simon").id
  url = ["http://basicgrowth.com/files/seed/article1.jpg", "http://basicgrowth.com/files/seed/article2.jpg", "http://basicgrowth.com/files/seed/article3.jpg", "http://basicgrowth.com/files/seed/article4.jpg"].sample
  Article.create!(
    title: title,
    description: description,
    remote_image_url: url,
    body: body,
    en_title: en_title,
    slug_en: title.parameterize + "-english",
    slug_nl: title.parameterize + "-dutch",
    en_description: en_description,
    en_body: en_body,
    category: category,
    posted: true,
    user_id: User.first.id)
end
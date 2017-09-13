require 'random_data'
require 'faker'

# Create Users 
10.times do 
  User.create!(
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password
  )
end

# Create Wikis
50.times do 
  Wiki.create!(
    title: Faker::HitchhikersGuideToTheGalaxy.starship,
    body: Faker::HitchhikersGuideToTheGalaxy.quote,
    private: Faker::Boolean.boolean
  )
end 



puts "Seeds finished"
puts "#{User.count} users created!"
puts "#{Wiki.count} wikis created!"
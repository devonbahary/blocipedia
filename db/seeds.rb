require 'random_data'

# Create Wikis
50.times do 
  Wiki.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph,
    private: RandomData.random_boolean
  )
end 



puts "Seeds finished"
puts "#{Wiki.count} wikis created!"
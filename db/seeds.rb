# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PublicActivity.enabled = false
User.create!({:first_name => "Guy", :last_name => "Bad", :email => "guy@gmail.com", :admin => true, :password => "sdjjks7dbjvs56567jhbciwed", :password_confirmation => "sdjjks7dbjvs56567jhbciwed" })
puts "User guy created"
Test.create!({free: true, name: "Test 1 - food"})
puts "Created Test 1 - food"
# Test.create!({free: false, name: "Test 1"})
# files = Dir.glob("../../shared/public/uploads/1/*.mp3")
# create_array = []
# files.each do |e|
#   filename = File.basename(e, ".*")
#   puts filename
#   sound = File.basename(e).gsub(/\s+/, '%20')
#   image_file = Dir.glob("../../shared/public/uploads/1/#{filename}.*g").first
#   if !image_file.nil?
#     image ||= File.basename(image_file).gsub(/\s+/, '%20')
#     create_array << {picture: "/uploads/1/#{image}", sound: "/uploads/1/#{sound}", test: Test.last}
#   end
# end
# Card.create!(create_array)

PublicActivity.enabled = true

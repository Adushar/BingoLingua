# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!({:email => "guy@gmail.com", :admin => true, :password => "sdjjks7dbjvs56567jhbciwed", :password_confirmation => "sdjjks7dbjvs56567jhbciwed" })
20.times {
  Card.create!([
    {picture: "https://southboundvapes.com/wp-content/uploads/2016/04/Natural-red-apple.jpg", sound: "https://www.computerhope.com/jargon/m/example.mp3", test: Test.last},
    {picture: "http://www.ogio.com/dw/image/v2/AADH_PRD/on/demandware.static/-/Sites-CGI-ItemMaster/en_US/v1529727192519/sits/ogio-bags-travel-2017-layover/ogio-bags-travel-2017-layover_15264___1.png", sound: "https://www.computerhope.com/jargon/m/example.mp3", test: Test.last},
    {picture: "https://cdn.shopify.com/s/files/1/0474/3081/products/2580_1400x.jpg", sound: "https://www.emijay.com/assets/images/cart-GGBOW-606-lg.jpghttps://www.computerhope.com/jargon/m/example.mp3", test: Test.last},
    {picture: "http://cdn.shopify.com/s/files/1/2011/3293/products/zombie-garden-gnome_1024x1024.jpg?v=1515570862", sound: "https://www.computerhope.com/jargon/m/example.mp3", test: Test.last},
    {picture: "https://i.pinimg.com/736x/98/f4/da/98f4dad0c89c7ce98565079e516edc59.jpg", sound: "https://www.computerhope.com/jargon/m/example.mp3", test: Test.last}
  ])
}

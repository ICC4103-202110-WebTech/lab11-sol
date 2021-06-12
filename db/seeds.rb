# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Initialize the review counter
ReviewCounter.create(count: 0)

# Populate the DB with fake data
Rake::Task['db:populate_fake_data'].invoke

# Run test model queries
Rake::Task['db:model_queries'].invoke

=begin
br1 = Brand.create(name: "Cristal")
br2 = Brand.create(name: "Escudo")
br3 = Brand.create(name: "Kunstmann")

be1 = Beer.create(brand: br1, beer_type: "Lager", alcvol: 5.0)
be2 = Beer.create(brand: br2, beer_type: "Lager", alcvol: 5.0)
be3 = Beer.create(brand: br3, beer_type: "Torobayo", alcvol: 5.0)
be4 = Beer.create(brand: br3, beer_type: "Alkoholfrei", alcvol: 0.1)

user1 = User.create(first_name: "Charlie", last_name: "Bernante", email: "charlie.bernante@slayer.com")
review1 = Review.create(user: user1, text: "I tried quite an awesome beer", rating: 4.4, beer: be1)
review2 = Review.create(user: user1, text: "Cool, with no alkohol!", rating: 3.0, beer: be4)

puts("Review count: #{ReviewCounter.first.count}")

puts("User 1's beers:")
puts(user1.beers.to_yaml)

puts("Beer 1's users:")
puts(be1.users.to_yaml)

begin
    puts("Attempting to create a user with invalid first name, last name and email.")
    inv_u = User.create!(first_name: 'f', last_name: 'l', email: 'emailaddress')
rescue => e
    puts(e.message)
end

begin
    user2 = User.create!(first_name: 'Dave', last_name: 'Lombardo', email: 'dave.lombardo@slayer.com')
    puts("Attempting to update a user with an invalid first name.")
    user2.first_name = 'D'
    user2.save!
rescue => e
    puts(e.message)
end

review1.destroy
puts("Review count: #{ReviewCounter.first.count}")

cn1 = Country.create(name: "Chile")
cn2 = Country.create(name: "Argentina")
cn3 = Country.create(name: "Holanda")
cn4 = Country.create(name: "Italia")
cn5 = Country.create(name: "Japón")
cn6 = Country.create(name: "Italia")
cn7 = Country.create(name: "Rusia")
cn8 = Country.create(name: "España")
cn9 = Country.create(name: "México")
cn10 = Country.create(name: "Dinamarca")
cn11= Country.create(name: "Turquía")

bw0 = Brewery.create(name: "CCU", estdate: 1911)
bw11 = Brewery.create(name: "Kunstmann", estdate: 1980)
bw1 = Brewery.create(name: "Carlsberg", estdate: 1710)
bw2 = Brewery.create(name: "Heineken", estdate: 1650)
bw3 = Brewery.create(name: "Asashi", estdate: 1940)
bw4 = Brewery.create(name: "Damm", estdate: 1811)
bw5 = Brewery.create(name: "Mahou", estdate: 1860)
bw6 = Brewery.create(name: "Erdinger", estdate: 1821)
bw7 = Brewery.create(name: "Peronni", estdate: 1867)
bw8 = Brewery.create(name: "Corona", estdate: 1905)
bw9 = Brewery.create(name: "Arsenaloye", estdate: 1927)
bw10 = Brewery.create(name: "Quilmes", estdate: 1899)

bw0.countries << cn1
be1.brewery = bw0
be1.save!

be2.brewery = bw0
be2.save!

be3.brewery = bw11
be3.save!

bw1.countries << cn10
bw1.countries << cn11
bw1.countries << cn10

bw2.countries << cn1
bw2.countries << cn3

bw2.countries << cn5
bw2.countries << cn6

cn8.breweries << bw4
cn8.breweries << bw5

puts("Countries that brew Carlsberg")
puts(bw1.countries.to_yaml)

puts("Breweries in Spain")
puts(cn8.breweries.to_yaml)
=end

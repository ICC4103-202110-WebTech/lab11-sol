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

# Make the first user admin
u = User.first
u.admin = true
u.save

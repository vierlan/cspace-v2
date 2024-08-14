# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

#raise StandardError, "DO NOT RUN THIS IN PRODUCTION" if Rails.env.production?
#
#require 'seed_support/rewardful'
#
#SeedSupport::Rewardful.run

# Profile.destroy_all
User.destroy_all

# Create an admin user with email and password and username
User.create!(email: 'lan@la.la', password: 123456, first_name: 'Lan', admin: true)
User.create!(email: 'dev@la.la', password: 123456, first_name: 'Dev', admin: true)

# Create a profile for user with bio and profession
# Profile.create!(user_id: 1, bio: 'I am a software developer', profession: 'Software Developer')
# Profile.create!(user_id: 2, bio: 'I am also a software developer', profession: 'Software Developer')

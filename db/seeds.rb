# coding: utf-8

User.create!(name: "Admin User",
             email: "admin@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)


puts "created sample-users"
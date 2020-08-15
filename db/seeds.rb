# coding: utf-8

User.create!(name: "Admin User",
             email: "admin@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "管理部",
             employee_number: "101",
             uid: "1111",
             admin: true)

User.create!(name: "上長A",
             email: "sample-a@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "業務部",
             employee_number: "102",
             uid: "2222",
             superior: true)

User.create!(name: "上長B",
             email: "sample-b@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "営業部",
             employee_number: "103",
             uid: "3333",
             superior: true)

puts "created sample-users"
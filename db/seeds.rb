User.create!(first_name:            "Paula",
             last_name:             "Lopez Pozuelo",
             email:                 "paula.pozuelo@songkick.com",
             sk_username:           "paula-lopez-pozuelo",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name:            "Maria",
             last_name:             "Lopez Pozuelo",
             email:                 "maria.pozuelo@songkick.com",
             sk_username:           "maria-lopez-pozuelo",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name:            "Sarah",
             last_name:             "Dear",
             email:                 "test1@songkick.com",
             sk_username:           "sarahdear",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name:            "Lucy",
             last_name:             "Dodridge",
             email:                 "test2@songkick.com",
             sk_username:           "lucy-dodridge",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

96.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "example.#{n+1}@songkick.com"
  sk_username = "example-#{n+1}"
  password = "password"
  User.create!(first_name: first_name,
               last_name: last_name,
               email: email,
               sk_username: sk_username,
               password: password,
               password_confirmation: password,
               activated: true,
              activated_at: Time.zone.now)
end

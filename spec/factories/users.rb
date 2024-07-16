FactoryBot.define do
  facoty :user do 
    name { "nickname" }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
FactoryBot.define do
  facoty :user do 
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
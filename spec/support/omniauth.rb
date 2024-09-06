RSpec.configure do |config|
  config.before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
                                                                  provider: 'google',
                                                                  uid: '123545',
                                                                  info: { email: 'test@example.com' }
                                                                })
  end
end

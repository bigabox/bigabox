OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '497656416978492', '418c31578577225b7deb7d2ab71ec707'
  
end


Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :twitter, 'AzwpvJviPbPxhB6lNJxLqw', 'MxHlhHuQ5UXawy81Cik26MOjRNvyUwJhuDq4yduICo'
end
# config/initializers/google_wallet.rb

GoogleWallet.configure do |config|
  config.load_credentials_from_file('config/google_api.json')
  config.issuer_id = Rails.application.credentials[:google_wallet_issuer_id]
  config.debug_mode = true
  config.logger = Logger.new(STDOUT)
end
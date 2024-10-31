# config/initializers/google_wallet.rb

GoogleWallet.configure do |config|
  config.load_credentials_from_file('config/google_api.json')
  config.issuer_id = '3388000000022805894'
  config.debug_mode = true
  config.logger = Logger.new(STDOUT)
end
Airbrake.configure do |config|
    config.api_key = '29e274987f6cb0d7a0ac5beb5f812bee'
    config.host    = 'errbit.hut.shefcompsci.org.uk'
    config.port    = 443
    config.secure  = config.port == 443
  end
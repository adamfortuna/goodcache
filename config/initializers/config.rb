if ENV['GOODREADS_KEY'] && ENV['GOODREADS_SECRET']
  APP_CONFIG = {
    'goodreads_key' => ENV['GOODREADS_KEY'],
    'goodreads_secret' => ENV['GOODREADS_SECRET']
  }
else
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
end

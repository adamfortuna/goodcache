if ENV['GOODREADS_KEY'] && ENV['GOODREADS_SECRET']
  APP_CONFIG = {
    'key' => ENV['GOODREADS_KEY'],
    'secret' => ENV['GOODREADS_SECRET']
  }
else
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
end

source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

end

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'

  gem 'rubocop'

  # install_if appeared in bundler 1.10...
  if respond_to?(:install_if)

    install_if lambda { Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.0') } do
      # Call 'byebug' anywhere in the code to stop execution and get a debugger console
      gem 'byebug'
    end

    # Install only for ruby >=2.1
    install_if lambda { Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.1') } do
      gem 'i18n-tasks'
    end
  end
end

group :test do
  gem 'minitest-focus'
  gem 'minitest-around'
  gem 'minitest-stub_any_instance'
  gem 'simplecov', require: false
  # gem 'capybara'
  gem 'selenium-webdriver'
  # gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'tidy-html5', github: 'moneyadviceservice/tidy-html5-gem'
  gem 'html_validation'

  gem 'rspec-rails', '~> 3.0.0'

  gem 'mapotempo_web_by_time_distance', github: 'Mapotempo/mapotempo_web_by_time_distance'
  gem 'mapotempo_web_import_vehicle_store', github: 'Mapotempo/mapotempo_web_import_vehicle_store'
end

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger', '< 0.20'
gem 'rack-cors'
gem 'swagger-docs'

gem 'rails-i18n'
gem 'http_accept_language'
gem 'execjs'
gem 'therubyracer'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'cancancan', '=1.11.0' # FIXME wait for ruby 2.0
gem 'lograge'
gem 'validates_timeliness'
gem 'rails_engine_decorators'

gem 'font-awesome-rails'
gem 'twitter-bootstrap-rails'
gem 'twitter_bootstrap_form_for', github: 'Mapotempo/twitter_bootstrap_form_for' # FIXME wait for pull request
gem 'bootstrap-filestyle-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-select-rails'

gem 'sanitize'
gem 'iconv'

gem 'pg', group: :production
gem 'rails_12factor', group: :production

gem 'leaflet-rails'
gem 'leaflet-markercluster-rails'
gem 'sprockets', '~> 2' # FIXME wait for https://github.com/rails/sprockets/issues/104
gem 'leaflet-draw-rails', github: 'frodrigo/leaflet-draw-rails' # FIXME wait for https://github.com/zentrification/leaflet-draw-rails/pull/1
gem 'leaflet_numbered_markers-rails', github: 'frodrigo/leaflet_numbered_markers-rails'
gem 'leaflet-control-geocoder-rails', github: 'frodrigo/leaflet-control-geocoder-rails'
gem 'leaflet-controlledbounds-rails', github: 'Mapotempo/leaflet-controlledbounds-rails'
gem 'leaflet-hash-rails', github: 'frodrigo/leaflet-hash-rails'
gem 'leaflet-pattern-rails', github: 'Mapotempo/leaflet-pattern-rails'
gem 'sidebar-v2-gh-pages-rails', github: 'Mapotempo/sidebar-v2-gh-pages-rails'
gem 'leaflet-encoded-rails', github: 'Mapotempo/leaflet-encoded-rails'

gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'jquery-tablesorter'
gem 'jquery-simplecolorpicker-rails'
gem 'jquery-timeentry-rails', github: 'frodrigo/jquery-timeentry-rails'
gem 'select2-rails', '=4.0.0' # FIXME test compatibility with planning sidebar
gem 'i18n-js'
gem 'mustache', '<1.0.0' # FIXME wait for ruby 2.0
gem 'smt_rails'
gem 'paloma'
gem 'browser', '<2.0.0' #FIXME wait for ruby 2.0
gem 'color'

gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'rgeo'
gem 'rgeo-geojson'
gem 'polylines'

gem 'ai4r'
gem 'sim_annealing'

gem 'nilify_blanks'
gem 'auto_strip_attributes'
gem 'amoeba'
gem 'carrierwave'

gem 'charlock_holmes'
gem 'savon'
gem 'savon-multipart', '~> 2.0.2'
gem 'rest-client'
gem 'macaddr'
gem 'rubyzip'

gem 'pnotify-rails'

gem 'nokogiri'
gem 'addressable'
gem 'icalendar'

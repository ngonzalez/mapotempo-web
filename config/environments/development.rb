Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Application config

  config.action_mailer.default_url_options = {host: 'localhost'}

  config.default_from_mail = 'root@localhost'

  config.swagger_docs_base_path = 'http://localhost:3000/'

  def cache_factory(namespace, expires_in)
    ActiveSupport::Cache::FileStore.new(File.join(Dir.tmpdir, namespace), namespace: namespace, expires_in: expires_in)
  end

#  config.optimize = Ort.new(
#    cache_factory('optimizer', 60*60*24*10),
#    'http://localhost:4567/0.1/optimize_tsptw'
#  )
  config.optimize = OptimizerWrapper.new(
    cache_factory('optimizer_wrapper', 60*60*24*10),
    'http://optim.mapotempo.com:1791/0.1',
    'demo'
  )
  config.optimize_time = 30
  config.optimize_cluster_size = 0
  config.optimize_soft_upper_bound = 3

  config.geocode_code_cache = cache_factory('geocode', 60*60*24*10)
  config.geocode_reverse_cache = cache_factory('geocode_reverse', 60*60*24*10)
  config.geocode_complete_cache = cache_factory('geocode_complete', 60*60*24*10)
  config.geocode_complete = false # Build time setting

  require 'geocode_addok_wrapper'
  config.geocode_geocoder = GeocodeAddokWrapper.new('https://geocode.mapotempo.com/0.1', 'secret_api_key')

  config.router_osrm = Routers::Osrm.new(
    cache_factory('osrm_request', 60*60*24*1),
    cache_factory('osrm_result', 60*60*24*1)
  )
  config.router_otp = Routers::Otp.new(
    cache_factory('otp_request', 60*60*24*1),
    cache_factory('otp_result', 60*60*24*1)
  )
  config.router_here = Routers::Here.new(
    cache_factory('here_request', 60*60*24*1),
    cache_factory('here_result', 60*60*24*1),
    'https://route.api.here.com/routing',
    'https://matrix.route.api.here.com/routing',
    'https://isoline.route.api.here.com/routing',
    nil,
    nil
  )
  config.router_wrapper = Routers::RouterWrapper.new(
    cache_factory('router_wrapper_request', 60*60*24*1),
    cache_factory('router_wrapper_result', 60*60*24*1),
    nil
  )

  config.devices.alyacom.api_url = 'http://preprod.intra.alyacom.fr/ws'
  config.devices.masternaut.api_url = 'http://ws.webservices.masternaut.fr/MasterWS/services'
  config.devices.masternaut.api_key = nil
  config.devices.orange.api_url = 'https://m2m-services.ft-dm.com'
  config.devices.orange.api_key = nil
  config.devices.tomtom.api_url = 'https://soap.business.tomtom.com/v1.26'
  config.devices.tomtom.api_key = nil
  config.devices.cache_object = cache_factory('devices', 30)

  config.delayed_job_use = true

  config.self_care = true # Allow subscription and resiliation by the user himself

  config.max_destinations = 3000
  config.manage_vehicles_only_admin = false

  config.enable_references = true
  config.enable_multi_visits = false
end

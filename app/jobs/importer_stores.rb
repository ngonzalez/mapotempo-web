# Copyright © Mapotempo, 2013-2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
require 'importer_base'
require 'geocoder_stores_job'

class ImporterStores < ImporterBase

  def max_lines
    Mapotempo::Application.config.max_destinations / 10
  end

  def columns
    {
      ref: {title: I18n.t('stores.import_file.ref'), desc: I18n.t('stores.import_file.ref_desc'), format: I18n.t('stores.import_file.format.string')},
      name: {title: I18n.t('stores.import_file.name'), desc: I18n.t('stores.import_file.name_desc'), format: I18n.t('stores.import_file.format.string'), required: I18n.t('stores.import_file.format.required')},
      street: {title: I18n.t('stores.import_file.street'), desc: I18n.t('stores.import_file.street_desc'), format: I18n.t('stores.import_file.format.string'), required: I18n.t('stores.import_file.format.advisable')},
      postalcode: {title: I18n.t('stores.import_file.postalcode'), desc: I18n.t('stores.import_file.postalcode_desc'), format: I18n.t('stores.import_file.format.integer'), required: I18n.t('stores.import_file.format.advisable')},
      city: {title: I18n.t('stores.import_file.city'), desc: I18n.t('stores.import_file.city_desc'), format: I18n.t('stores.import_file.format.string'), required: I18n.t('stores.import_file.format.advisable')},
      country: {title: I18n.t('stores.import_file.country'), desc: I18n.t('stores.import_file.country_desc'), format: I18n.t('stores.import_file.format.string')},
      lat: {title: I18n.t('stores.import_file.lat'), desc: I18n.t('stores.import_file.lat_desc'), format: I18n.t('stores.import_file.format.float')},
      lng: {title: I18n.t('stores.import_file.lng'), desc: I18n.t('stores.import_file.lng_desc'), format: I18n.t('stores.import_file.format.float')},
      geocoding_accuracy: {title: I18n.t('stores.import_file.geocoding_accuracy'), desc: I18n.t('stores.import_file.geocoding_accuracy_desc'), format: I18n.t('stores.import_file.format.float')},
      geocoding_level: {title: I18n.t('stores.import_file.geocoding_level'), desc: I18n.t('stores.import_file.geocoding_level_desc'), format: '[' + ::Store::GEOCODING_LEVEL.keys.join(' | ') + ']'},
      color: {title: I18n.t('stores.import_file.color'), desc: I18n.t('stores.import_file.color_desc'), format: I18n.t('stores.import_file.color_format')},
      icon: {title: I18n.t('stores.import_file.icon'), desc: I18n.t('stores.import_file.icon_desc'), format: I18n.t('stores.import_file.format.string')},
      icon_size: {title: I18n.t('stores.import_file.icon_size'), desc: I18n.t('stores.import_file.icon_size_desc'), format: '[' + ::Store::ICON_SIZE.join(' | ') + ']'},
    }
  end

  def json_to_rows(json)
    json
  end

  def rows_to_json(rows)
    rows
  end

  def before_import(name, options)
    @stores_to_geocode = []

    if options[:replace]
      # vehicle is always linked to a store
      @tmp_store = @customer.stores.build(
        name: I18n.t('stores.default.name'),
        city: I18n.t('stores.default.city'),
        lat: Float(I18n.t('stores.default.lat')),
        lng: Float(I18n.t('stores.default.lng'))
      )
      @customer.vehicle_usage_sets.each{ |vehicle_usage_set|
        vehicle_usage_set.store_start = @tmp_store
        vehicle_usage_set.store_stop = @tmp_store
      }
      @customer.save!
      @customer.stores.each{ |store|
        if store != @tmp_store
          @customer.stores.destroy(store)
        end
      }
    end
  end

  def import_row(name, row, line, options)
    if row[:name].nil?
      raise ImportInvalidRow.new(I18n.t('stores.import_file.missing_name', line: (row[:line] || line)))
    end
    if row[:city].nil? && row[:postalcode].nil? && (row[:lat].nil? || row[:lng].nil?)
      raise ImportInvalidRow.new(I18n.t('stores.import_file.missing_location', line: (row[:line] || line)))
    end

    [:lat, :lng].each do |name|
      begin
        if !row[name].nil? && row[name].is_a?(String)
          row[name] = Float(row[name].tr(',', '.'))
        end
      rescue ArgumentError => e
        if e.message =~ /invalid value for Float/
          raise ImportInvalidRow.new(I18n.t('stores.import_file.invalid_numeric_value', line: (row[:line] || line), value: row[name]))
        else
          raise e
        end
      end
    end

    if !row[:ref].nil? && !row[:ref].strip.empty?
      store = @customer.stores.find{ |store|
        store.ref && store.ref == row[:ref]
      }
      store.assign_attributes(row) if store
    end

    if !store
      store = @customer.stores.build(row) # Link only when store is complete
    end

    if !store.position?
      @stores_to_geocode << store
    end

    store # For subclasses
  end

  def after_import(name, options)
    if options[:replace]
      if !@customer.stores[1].nil?
        @customer.vehicle_usage_sets.each{ |vehicle_usage_set|
          vehicle_usage_set.store_start = @customer.stores[1]
          vehicle_usage_set.store_stop = @customer.stores[1]
          vehicle_usage_set.save!
        }
      end
      @customer.stores.destroy(@tmp_store)
    end

    if !@stores_to_geocode.empty? && (@synchronous || !Mapotempo::Application.config.delayed_job_use)
      @stores_to_geocode.each_slice(50){ |stores|
        geocode_args = stores.collect(&:geocode_args)
        begin
          results = Mapotempo::Application.config.geocode_geocoder.code_bulk(geocode_args)
          stores.zip(results).each { |store, result|
            store.geocode_result(result) if result
          }
        rescue GeocodeError # avoid stop import because of geocoding job
        end
      }
    end

    @customer.save!
  end

  def finalize_import(name, options)
    if !@stores_to_geocode.empty? && !@synchronous && Mapotempo::Application.config.delayed_job_use
      @customer.job_store_geocoding = Delayed::Job.enqueue(GeocoderStoresJob.new(@customer.id))
    end

    @customer.save!
    true
  end
end

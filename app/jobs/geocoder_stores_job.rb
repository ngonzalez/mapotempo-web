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
class GeocoderStoresJob < Struct.new(:customer_id)

  def before(job)
    @job = job
  end

  def perform
    customer = Customer.find(customer_id)
    Delayed::Worker.logger.info "GeocoderStoresJob customer_id=#{customer_id} perform"
    count = customer.stores.where(lat: nil).count
    i = 0
    customer.stores.select(:id).where(lat: nil).each_slice(50){ |store_ids|
      Store.transaction do
        stores = customer.stores.find store_ids # IMPORTANT: Lower Delayed Job Memory Usage
        geocode_args = stores.collect(&:geocode_args)
        begin
          results = Mapotempo::Application.config.geocode_geocoder.code_bulk(geocode_args)
          stores.zip(results).each { |store, result|
            store.geocode_result(result) if result
            store.save!
            i += 1
          }
        rescue GeocodeError # avoid stop import because of geocoding job
        end
        @job.progress = Integer(i * 100 / count).to_s
        @job.save!
        Delayed::Worker.logger.info "GeocoderStoresJob customer_id=#{customer_id} #{@job.progress}%"
      end
    }
  end
end

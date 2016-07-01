# Copyright © Mapotempo, 2016
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
class TeksatService < DeviceService
  def initialize(params)
    super params
    service.ticket_id = params[:ticket_id]
  end

  def authenticate(params)
    service.authenticate customer, params
  end

  def list_devices
    with_cache [:list_devices, service_name, customer.id, customer.teksat_username] do
      service.list_devices customer
    end
  end

  def get_vehicles_pos
    with_cache [:get_vehicles_pos, service_name, customer.id, customer.teksat_username] do
      service.get_vehicles_pos customer
    end
  end
end

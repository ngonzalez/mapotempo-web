# Copyright © Mapotempo, 2014-2015
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
class V01::Entities::Vehicle < Grape::Entity
  def self.entity_name
    'V01_Vehicle'
  end

  expose(:id, documentation: { type: Integer })
  expose(:contact_email, documentation: { type: String })
  expose(:ref, documentation: { type: String })
  expose(:name, documentation: { type: String })
  expose(:emission, documentation: { type: Integer })
  expose(:consumption, documentation: { type: Integer })
  expose(:capacity, documentation: { type: Integer })
  expose(:color, documentation: { type: String, desc: 'Color code with #. For instance: #FF0000' })
  expose(:capacity_unit, documentation: { type: String })
  expose(:tomtom_id, documentation: { type: String })
  expose(:router_id, documentation: { type: Integer })
  expose(:speed_multiplicator, documentation: { type: Float })
  expose(:vehicle_usages, using: V01::Entities::VehicleUsage, documentation: { type: V01::Entities::VehicleUsage, is_array: true, param_type: 'form' })
end

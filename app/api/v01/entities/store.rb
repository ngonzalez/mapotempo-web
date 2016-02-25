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
class V01::Entities::Store < Grape::Entity
  def self.entity_name
    'V01_Store'
  end

  expose(:id, documentation: { type: Integer })
  expose(:ref, documentation: { type: String })
  expose(:name, documentation: { type: String })
  expose(:street, documentation: { type: String })
  expose(:postalcode, documentation: { type: String })
  expose(:city, documentation: { type: String })
  expose(:country, documentation: { type: String })
  expose(:lat, documentation: { type: Float })
  expose(:lng, documentation: { type: Float })
  expose(:color, documentation: { type: String, desc: 'Color code with #. Default: #000000.' })
  expose(:icon, documentation: { type: String, desc: 'Icon name from font-awesome. Default: fa-home.' })
  expose(:icon_size, documentation: { type: String, values: ['large', 'medium', 'small'], desc: 'Icon size. Default: large.' })
  expose(:geocoding_accuracy, documentation: { type: Float })
  expose(:geocoding_level, documentation: { type: String, values: ['point', 'house', 'street', 'intersection', 'city'] })
end

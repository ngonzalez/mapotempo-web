# Copyright © Mapotempo, 2014-2016
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
class V01::Entities::Stop < Grape::Entity
  def self.entity_name
    'V01_Stop'
  end

  expose(:id, documentation: { type: Integer })
  expose(:visit_ref, documentation: { type: String }) { |stop|
    if stop.is_a?(StopVisit) && stop.visit
      stop.visit.ref
    end
  }
  expose(:destination_ref, documentation: { type: String }) { |stop|
    if stop.is_a?(StopVisit) && stop.visit && stop.visit.destination
      stop.visit.destination.ref
    end
  }
  expose(:index, documentation: { type: Integer })
  expose(:active, documentation: { type: 'Boolean' })
  expose(:distance, documentation: { type: Float, desc: 'Distance between the stop and previous one.' })
  expose(:drive_time, documentation: { type: Integer, desc: 'Time in seconds between the stop and previous one.' })
  expose(:trace, documentation: { type: String, desc: 'Trace between the stop and previous one.' })
  expose(:visit_id, documentation: { type: Integer })
  # Deprecated
  expose(:destination_id, documentation: { type: Integer }) { |m| m.is_a?(StopVisit) ? m.visit.destination.id : nil }
  expose(:wait_time, documentation: { type: DateTime, desc: 'Time before delivery.' }) { |m| m.wait_time && ('%i:%02i:%02i' % [m.wait_time / 60 / 60, m.wait_time / 60 % 60, m.wait_time % 60]) }
  expose(:time, documentation: { type: DateTime, desc: 'Delivered at.' }) { |m|
    if m.time
      (m.route.planning.date || Time.zone.today).beginning_of_day + (m.time - Time.zone.local(2000, 1, 1))
    end
  }
  expose(:out_of_window, documentation: { type: 'Boolean' })
  expose(:out_of_capacity, documentation: { type: 'Boolean' })
  expose(:out_of_drive_time, documentation: { type: 'Boolean' })
end

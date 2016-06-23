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
class Zoning < ActiveRecord::Base
  belongs_to :customer
  has_many :zones, -> { order('id') }, inverse_of: :zoning, dependent: :delete_all, autosave: true, after_add: :touch_zones, after_remove: :touch_zones
  has_and_belongs_to_many :plannings, autosave: true

  accepts_nested_attributes_for :zones, allow_destroy: true
  validates_associated_bubbling :zones

  nilify_blanks
  auto_strip_attributes :name
  validates :name, presence: true

  before_create :update_out_of_date
  before_save :update_out_of_date

  amoeba do
    exclude_association :plannings

    customize(lambda { |_original, copy|
      def copy.update_out_of_date; end

      copy.zones.each{ |zone|
        zone.zoning = copy
      }
    })
  end

  def duplicate
    copy = self.amoeba_dup
    copy.name += " (%s)" % [I18n.l(Time.zone.now, format: :long)]
    copy
  end

  def apply(visits)
    visits.group_by{ |visit|
      inside(visit.destination)
    }
  end

  # Return the zone with vehicle and max distance from the border
  def inside(destination)
    z = zones.select(&:vehicle_id).collect{ |zone|
      [zone, zone.inside_distance(destination.lat, destination.lng)]
    }.select{ |zone, d|
      d
    }.max_by{ |zone, d|
      d
    }
    z[0] if z
  end

  def flag_out_of_date
    plannings.each{ |planning|
      planning.zoning_out_of_date = true
    }
  end

  def automatic_clustering(planning, n)
    positions = (planning ? planning.routes.collect{ |route| route.stops }.flatten : customer.destinations).collect{ |stop|
      if stop.position?
        [stop.lat, stop.lng]
      end
    }.compact.uniq

    vehicles = planning ? planning.vehicle_usage_set.vehicle_usages.select(&:active).collect(&:vehicle).to_a : customer.vehicles.to_a
    clusters = Clustering.clustering(positions, n || vehicles.size)
    zones.clear
    Clustering.hulls(clusters).each{ |hull|
      zones.build({polygon: hull, vehicle: vehicles.shift})
    }
  end

  def from_planning(planning)
    zones.clear
    clusters = planning.routes.select(&:vehicle_usage).collect{ |route|
      route.stops.select{ |stop| stop.is_a?(StopVisit) }.collect{ |stop|
        if stop.position?
          [stop.lat, stop.lng]
        end
      }.compact.uniq
    }
    routes = planning.routes.select(&:vehicle_usage)
    Clustering.hulls(clusters).each{ |hull|
      route = routes.shift
      if hull
        name = (route.ref) ? I18n.t('zonings.default.from_route') + ' ' + route.ref : nil
        zones.build({polygon: hull, name: name, vehicle: route.vehicle_usage.vehicle})
      end
    }
  end

  def isochrone?(vehicle_usage_set, from_store = true)
    isowhat?(:isochrone?, vehicle_usage_set)
  end

  def isochrone(size, vehicle_usage = nil, loc = nil)
    isowhat(:isochrone?, :isochrone, size, vehicle_usage, loc)
  end

  def isochrones(size, vehicle_usage_set)
    isowhats(:isochrone?, :isochrone, size, vehicle_usage_set)
  end

  def isodistance?(vehicle_usage_set, from_store = true)
    isowhat?(:isodistance?, vehicle_usage_set)
  end

  def isodistance(size, vehicle_usage = nil, loc = nil)
    isowhat(:isodistance?, :isodistance, size, vehicle_usage, loc)
  end

  def isodistances(size, vehicle_usage_set)
    isowhats(:isodistance?, :isodistance, size, vehicle_usage_set)
  end

  private

  def update_out_of_date
    if @collection_touched
      flag_out_of_date
    end
  end

  def touch_zones(_zone)
    @collection_touched = true
  end

  def isowhat?(what, vehicle_usage_set, from_store = true)
    vehicle_usage_set.vehicle_usages.select(&:active).find{ |vehicle_usage|
      router = vehicle_usage.vehicle.default_router
      router.method(what).call && (vehicle_usage.default_store_start.try(&:position?) || !from_store)
    }
  end

  def isowhats(what_qm, what, size, vehicle_usage_set)
    zones.clear
    vehicle_usage_set.vehicle_usages.select(&:active).each{ |vehicle_usage|
      isowhat(what_qm, what, size, vehicle_usage, nil)
    }
  end

  def isowhat(what_qm, what, size, vehicle_usage, loc)
    return unless vehicle_usage || loc
    router = vehicle_usage ? vehicle_usage.vehicle.default_router : customer.router
    size_to_human = what == :isochrone ? (size / 60).to_s + ' ' + I18n.t('all.unit.minute') : (size / 1000).to_s + ' ' + I18n.t('all.unit.km')
    name = I18n.t('zonings.default.from_' + what.to_s) + ' ' + size_to_human
    if !loc
      loc = [vehicle_usage.default_store_start.try(&:lat), vehicle_usage.default_store_start.try(&:lng)]
      name += ' ' + I18n.t('zonings.default.from') + ' ' + vehicle_usage.default_store_start.name if vehicle_usage.try(&:default_store_start)
    end

    if router.method(what_qm).call && loc[0] && loc[1]
      geom = router.method('compute_' + what.to_s).call(loc[0], loc[1], size, vehicle_usage ? vehicle_usage.vehicle.default_speed_multiplicator : customer.speed_multiplicator)
    end
    if geom
      zone = vehicle_usage && zones.to_a.find{ |zone| zone.vehicle_id == vehicle_usage.vehicle.id }
      if zone
        zone.polygon = geom
        zone.name = name
      else
        zones.build({polygon: geom, name: name, vehicle: vehicle_usage.try(&:vehicle)})
      end
    end
  end
end

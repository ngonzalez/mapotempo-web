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
class Route < ActiveRecord::Base
  belongs_to :planning
  belongs_to :vehicle_usage
  has_many :stops, -> { order(:index) }, inverse_of: :route, autosave: true, dependent: :delete_all

  nilify_blanks
  auto_strip_attributes :ref
  validates :planning, presence: true
#  validates :vehicle_usage, presence: true # nil on unplanned route
  validate :stop_index_validation

  before_save :update_vehicle_usage

  after_initialize :assign_defaults, if: 'new_record?'

  amoeba do
    enable

    customize(lambda { |original, copy|
      copy.planning = original.planning
      copy.stops.each{ |stop|
        stop.route = copy
      }
    })
  end

  def init_stops(ignore_errors = false)
    stops.clear
    if vehicle_usage && vehicle_usage.default_rest_duration
      stops.build(type: StopRest.name, active: true, index: 1)
    end

    compute(ignore_errors)
  end

  def default_stops
    i = stops.size
    planning.visits_compatibles.each { |visit|
      stops.build(type: StopVisit.name, visit: visit, active: true, index: i += 1)
    }
  end

  def service_time_start_value
    vehicle_usage.default_service_time_start - Time.utc(2000, 1, 1, 0, 0) if vehicle_usage && vehicle_usage.default_service_time_start
  end

  def service_time_end_value
    vehicle_usage.default_service_time_end - Time.utc(2000, 1, 1, 0, 0) if vehicle_usage && vehicle_usage.default_service_time_end
  end

  def plan(departure = nil, ignore_errors = false)
    self.touch if self.id # To force route save in case none attribute has changed below
    self.out_of_date = false
    self.distance = 0
    self.stop_distance = 0
    self.stop_trace = nil
    self.stop_out_of_drive_time = nil
    self.emission = 0
    self.start = self.end = nil
    last_lat, last_lng = nil, nil
    if vehicle_usage && stops.size > 0
      service_time_start = service_time_start_value
      service_time_end = service_time_end_value
      self.end = self.start = departure || vehicle_usage.default_open
      speed_multiplicator = vehicle_usage.vehicle.default_speed_multiplicator
      if !vehicle_usage.default_store_start.nil? && !vehicle_usage.default_store_start.lat.nil? && !vehicle_usage.default_store_start.lng.nil?
        last_lat, last_lng = vehicle_usage.default_store_start.lat, vehicle_usage.default_store_start.lng
      end
      quantity = 0
      router = vehicle_usage.vehicle.default_router
      stops_time = {}

      # Add service time
      if !service_time_start.nil?
        self.end += service_time_start
      end

      stops_sort = stops.sort_by(&:index)
      stops_sort.each_with_index{ |stop, index|
        if stop.active && (stop.position? || (stop.is_a?(StopRest) && stop.open && stop.close && stop.duration))
          if stop.position? && !last_lat.nil? && !last_lng.nil?
            begin
              stop.distance, stop.drive_time, stop.trace = router.trace(speed_multiplicator, last_lat, last_lng, stop.lat, stop.lng)
            rescue RouterError => e
              raise if !ignore_errors
            end
          else
            stop.distance, stop.drive_time, stop.trace = nil, nil, nil
          end
          if stop.drive_time
            stops_time[stop] = stop.drive_time
            stop.time = self.end + stop.drive_time
          elsif stop.is_a?(StopRest)
            stop.time = self.end
          else
            stop.time = nil
          end

          if stop.time
            if stop.open && stop.time < stop.open
              stop.wait_time = stop.open - stop.time
              stop.time = stop.open
            else
              stop.wait_time = nil
            end
            stop.out_of_window = (stop.open && stop.time < stop.open) || (stop.close && stop.time > stop.close)

            if stop.distance
              self.distance += stop.distance
            end
            self.end = stop.time + stop.duration

            if stop.is_a?(StopVisit)
              quantity += (stop.visit.quantity || 1)
              stop.out_of_capacity = vehicle_usage.vehicle.capacity && quantity > vehicle_usage.vehicle.capacity
            end

            stop.out_of_drive_time = stop.time > vehicle_usage.default_close
          end

          if stop.position?
            last_lat, last_lng = stop.lat, stop.lng
          end

        else
          stop.active = stop.out_of_capacity = stop.out_of_drive_time = stop.out_of_window = false
          stop.distance = stop.trace = stop.time = stop.wait_time = nil
        end
      }

      if !last_lat.nil? && !last_lng.nil? && vehicle_usage.default_store_stop && !vehicle_usage.default_store_stop.lat.nil? && !vehicle_usage.default_store_stop.lng.nil?
        begin
          distance, drive_time, trace = router.trace(speed_multiplicator, last_lat, last_lng, vehicle_usage.default_store_stop.lat, vehicle_usage.default_store_stop.lng)
        rescue RouterError => e
          raise if !ignore_errors
        end
      else
        distance, drive_time, trace = nil, nil, nil
      end
      if drive_time
        self.distance += distance
        stops_time[:stop] = drive_time
        self.end += drive_time
        self.stop_distance, self.stop_drive_time = distance, drive_time
      end

      # Add service time to end point
      if !service_time_end.nil?
        self.end += service_time_end
      end

      self.stop_trace = trace
      self.stop_out_of_drive_time = self.end > vehicle_usage.default_close

      self.emission = vehicle_usage.vehicle.emission.nil? || vehicle_usage.vehicle.consumption.nil? ? nil : self.distance / 1000 * vehicle_usage.vehicle.emission * vehicle_usage.vehicle.consumption / 100

      [stops_sort, stops_time]
    end
  end

  def compute(ignore_errors = false)
    stops_sort, stops_time = plan(nil, ignore_errors)

    if stops_sort
      # Try to minimize waiting time by a later begin
      time = self.end
      time -= stops_time[:stop] if stops_time[:stop]
      (time -= vehicle_usage.default_service_time_end - Time.utc(2000, 1, 1, 0, 0)) if vehicle_usage.default_service_time_end
      stops_sort.reverse_each{ |stop|
        if stop.active && (stop.position? || stop.is_a?(StopRest))
          if stop.time && (stop.out_of_window || (stop.close && time > stop.close))
            time = stop.time
          else
            # Latest departure time
            time = [time, stop.close].min if stop.close

            # New arrival stop time
            time -= stop.duration
          end

          # Previous departure time
          time -= stops_time[stop] if stops_time[stop]
        end
      }

      (time -= vehicle_usage.default_service_time_start - Time.utc(2000, 1, 1, 0, 0)) if vehicle_usage.default_service_time_start
      if time > start
        # We can sleep a bit more on morning, shift departure
        plan(time, ignore_errors)
      end
    end

    true
  end

  def set_visits(visits, recompute = true, ignore_errors = false)
    Stop.transaction do
      stops.select{ |stop| stop.is_a?(StopVisit) }.each{ |stop|
        remove_stop(stop)
      }
      add_visits(visits, recompute, ignore_errors)
    end
  end

  def add_visits(visits, recompute = true, ignore_errors = false)
    Stop.transaction do
      i = stops.size
      visits.each{ |stop|
        visit, active = stop
        stops.build(type: StopVisit.name, visit: visit, active: active, index: i += 1)
      }
      compute(ignore_errors) if recompute
    end
  end

  def add(visit, index = nil, active = false, stop_id = nil)
    index = stops.size + 1 if index && index < 0
    if index
      shift_index(index)
    elsif vehicle_usage
      raise
    end
    stops.build(type: StopVisit.name, visit: visit, index: index, active: active, id: stop_id)

    if vehicle_usage
      self.out_of_date = true
    end
  end

  def add_rest(active = true, stop_id = nil)
    index = stops.size + 1
    stops.build(type: StopRest.name, index: index, active: active, id: stop_id)
    self.out_of_date = true
  end

  def add_or_update_rest(active = true, stop_id = nil)
    if !stops.find{ |stop| stop.is_a?(StopRest) }
      add_rest(active, stop_id)
    end
    self.out_of_date = true
  end

  def remove_visit(visit)
    stops.each{ |stop|
      if(stop.is_a?(StopVisit) && stop.visit == visit)
        remove_stop(stop)
      end
    }
  end

  def remove_stop(stop)
    if vehicle_usage
      shift_index(stop.index + 1, -1)
      self.out_of_date = true
    end
    stops.destroy(stop)
  end

  def move_visit(visit, index)
    stop = nil
    planning.routes.find{ |route|
      (route != self ? route : self).stops.find{ |s|
        if s.is_a?(StopVisit) && s.visit == visit
          stop = s
        end
      }
    }
    if stop
      move_stop(stop, index)
    end
  end

  def move_stop(stop, index, force = false)
    if stop.route != self
      if stop.is_a?(StopVisit)
        visit, active = stop.visit, stop.active
        stop_id = stop.id
        stop.route.move_stop_out(stop)
        add(visit, index, active || stop.route.vehicle_usage.nil?, stop_id)
      elsif force && stop.is_a?(StopRest)
        active = stop.active
        stop_id = stop.id
        stop.route.move_stop_out(stop, force)
        add_rest(active, stop_id)
      end
    else
      index = stops.size if index < 0
      if stop.index
        if index < stop.index
          shift_index(index, 1, stop.index - 1)
        else
          shift_index(stop.index + 1, -1, index)
        end
        stop.index = index
      end
    end
    compute
  end

  def move_stop_out(stop, force = false)
    if force || stop.is_a?(StopVisit)
      if vehicle_usage
        shift_index(stop.index + 1, -1)
      end
      stop.active = false
      compute
      stop.route.stops.destroy(stop)
    end
  end

  def force_reindex
    # Force reindex after customers.destination.destroy_all
    stops.each_with_index{ |stop, index|
      stop.index = index + 1
    }
  end

  def sum_out_of_window
    stops.to_a.sum{ |stop|
      (stop.time && stop.open && stop.time < stop.open ? stop.open - stop.time : 0) +
      (stop.time && stop.close && stop.time > stop.close ? stop.time - stop.close : 0)
    }
  end

  def optimize(matrix_progress, &optimizer)
    stops_on = stops_segregate[true]
    router = vehicle_usage.vehicle.default_router
    position_start = (vehicle_usage.default_store_start && !vehicle_usage.default_store_start.lat.nil? && !vehicle_usage.default_store_start.lng.nil?) ? [vehicle_usage.default_store_start.lat, vehicle_usage.default_store_start.lng] : [nil, nil]
    position_stop = (vehicle_usage.default_store_stop && !vehicle_usage.default_store_stop.lat.nil? && !vehicle_usage.default_store_stop.lng.nil?) ? [vehicle_usage.default_store_stop.lat, vehicle_usage.default_store_stop.lng] : [nil, nil]
    amalgamate_stops_same_position(stops_on) { |positions|
      tws = [[nil, nil, 0]] + positions.collect{ |position|
        open, close, duration = position[2..4]
        open = open ? Integer(open - vehicle_usage.default_open) : nil
        close = close ? Integer(close - vehicle_usage.default_open) : nil
        if open && close && open > close
          close = open
        end
        [open, close, duration]
      }

      positions = [position_start] + positions + [position_stop]
      speed_multiplicator = vehicle_usage.vehicle.default_speed_multiplicator
      order = unnil_positions(positions, tws){ |positions, tws, rest_tws|
        positions = positions[(position_start == [nil, nil] ? 1 : 0)..(position_stop == [nil, nil] ? -2 : -1)].collect{ |position| position[0..1] }
        matrix = router.matrix(positions, positions, speed_multiplicator, 'time', &matrix_progress)
        if position_start == [nil, nil]
          matrix = [[[0, 0]] * matrix.length] + matrix
          matrix.collect!{ |x| [[0, 0]] + x }
        end
        if position_stop == [nil, nil]
          matrix += [[[0, 0]] * matrix.length]
          matrix.collect!{ |x| x + [[0, 0]] }
        end
        optimizer.call(matrix, tws, rest_tws)
      }
      order[1..-2].collect{ |i| i - 1 }
    }
  end

  def order(o)
    stops_ = stops_segregate
    a = o.collect{ |i|
      stops_[true][i].out_of_window = false
      stops_[true][i]
    }
    a += ((0..stops_[true].size - 1).to_a - o).collect{ |i|
      stops_[true][i].active = false
      stops_[true][i].out_of_window = true
      stops_[true][i]
    }
    a += (stops_[false] || [])
    i = 0
    a.each{ |stop|
      stop.index = i += 1
    }
  end

  def active(action)
    if action == :reverse
      stops.each{ |stop|
        stop.active = !stop.active
      }
      true
    elsif action == :all || action == :none
      stops.each{ |stop|
        stop.active = action == :all
      }
      true
    else
      false
    end
  end

  def size_active
    stops.to_a.sum(0) { |stop|
      (stop.active || !vehicle_usage) ? 1 : 0
    }
  end

  def quantity
    stops.to_a.sum(0) { |stop|
      stop.is_a?(StopVisit) && (stop.active || !vehicle_usage) ? (stop.visit.quantity || 1) : 0
    }
  end

  def active_all
    stops.each { |stop|
      if stop.position?
        stop.active = true
      end
    }
    compute
  end

  def reverse_order
    stops.sort_by{ |stop| -stop.index }.each_with_index{ |stop, index|
      stop.index = index + 1
    }
  end

  def out_of_date
    vehicle_usage && self[:out_of_date]
  end

  def to_s
    "#{ref}:#{vehicle_usage && vehicle_usage.vehicle.name}=>[" + stops.collect(&:to_s).join(', ') + ']'
  end

  private

  def assign_defaults
    self.hidden = false
    self.locked = false
  end

  def stops_segregate
    stops.group_by{ |stop| !!(stop.active && (stop.position? || stop.is_a?(StopRest))) }
  end

  def shift_index(from, by = 1, to = nil)
    stops.partition{ |stop|
      stop.index.nil? || stop.index < from || (to && stop.index > to)
    }[1].each{ |stop|
      stop.index += by
    }
  end

  def stop_index_validation
    if vehicle_usage_id && stops.length > 0 && stops.collect(&:index).sum != (stops.length * (stops.length + 1)) / 2
      errors.add(:stops, :bad_index)
    end
  end

  def amalgamate_stops_same_position(stops)
    tws = stops.find{ |stop|
      stop.is_a?(StopRest) || stop.open || stop.close
    }

    if tws
      # Can't reduce cause of time windows
      positions_uniq = stops.collect{ |stop|
        [stop.lat, stop.lng, stop.open, stop.close, stop.duration]
      }

      yield(positions_uniq)
    else
      # Reduce positions vector size by amalgamate points in same position
      stock = Hash.new { [] }
      i = -1
      stops.each{ |stop|
        stock[[stop.lat, stop.lng]] += [[stop, i += 1]]
      }

      positions_uniq = stock.collect{ |k, v|
        k + [nil, nil, v.sum{ |vs| vs[0].duration }]
      }

      optim_uniq = yield(positions_uniq)

      optim_uniq.collect{ |ou|
        stock[positions_uniq[ou][0..1]]
      }.flatten(1).collect{ |pa|
        pa[1]
      }
    end
  end

  def unnil_positions(positions, tws)
    # start/stop are not removed in case they are not geocoded
    not_nil_position_index = positions[1..-2].each_with_index.group_by{ |position, index| !position[0].nil? && !position[1].nil? }

    if not_nil_position_index.key?(true)
      not_nil_position = not_nil_position_index[true].collect{ |position, index| position }
      not_nil_tws = not_nil_position_index[true][0..-1].collect{ |position, index| tws[index + 1] }
      not_nil_index = not_nil_position_index[true].collect{ |position, index| index + 1 }
    else
      not_nil_position = []
      not_nil_tws = []
      not_nil_index = []
    end
    if not_nil_position_index.key?(false)
      nil_tws = not_nil_position_index[false].collect{ |position, index| tws[index + 1] }
      nil_index = not_nil_position_index[false].collect{ |position, index| index + 1 }
    else
      nil_tws = []
      nil_index = []
    end

    order = yield([positions[0]] + not_nil_position + [positions[-1]], [tws[0]] + not_nil_tws, nil_tws)

    all_index = [0] + not_nil_index + [positions.length - 1] + nil_index
    order.collect{ |o| all_index[o] }
  end

  def update_vehicle_usage
    if vehicle_usage_id_changed?
      self.out_of_date = true
    end
  end
end

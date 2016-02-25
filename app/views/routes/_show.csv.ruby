if route.vehicle_usage && @export_stores
  csv << [
    route.ref || (route.vehicle_usage && route.vehicle_usage.vehicle.name),
    (route.vehicle_usage.vehicle.ref if route.vehicle_usage),
    0,
    I18n.t('plannings.export_file.stop_type_store'),
    nil,
    nil,
    (l(route.start, format: :hour_minute) if route.start),
    0,
    0,
    nil,
    nil,
    nil,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.ref,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.name,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.street,
    nil,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.postalcode,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.city,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.country,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.lat,
    route.vehicle_usage.default_store_start && route.vehicle_usage.default_store_start.lng,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil
  ]
end

index = 0
route.stops.each { |stop|
  csv << [
    route.ref || (route.vehicle_usage && route.vehicle_usage.vehicle.name),
    (route.vehicle_usage.vehicle.ref if route.vehicle_usage),
    (index+=1 if route.vehicle_usage),
    stop.is_a?(StopVisit) ? I18n.t('plannings.export_file.stop_type_visit') : I18n.t('plannings.export_file.stop_type_rest'),
    ((stop.active ? '1' : '0') if route.vehicle_usage),
    ("%i:%02i" % [stop.wait_time/60/60, stop.wait_time/60%60] if route.vehicle_usage && stop.wait_time),
    (l(stop.time, format: :hour_minute) if route.vehicle_usage && stop.time),
    (stop.distance if route.vehicle_usage),
    (stop.drive_time if route.vehicle_usage),
    stop.out_of_window ? 'x' : '',
    stop.out_of_capacity ? 'x' : '',
    stop.out_of_drive_time ? 'x' : '',
    stop.is_a?(StopVisit) ? stop.visit.destination.ref : stop.ref,
    stop.name,
    stop.street,
    stop.detail,
    stop.postalcode,
    stop.city,
    stop.country,
    stop.lat,
    stop.lng,
    stop.comment,
    stop.phone_number,
    (stop.visit.destination.tags.collect(&:label).join(',') if stop.is_a?(StopVisit)),
    (stop.visit.ref if stop.is_a?(StopVisit)),
    stop.is_a?(StopVisit) ? (stop.visit.take_over ? l(stop.visit.take_over, format: :hour_minute_second) : nil) : (route.vehicle_usage.default_rest_duration ? l(route.vehicle_usage.default_rest_duration, format: :hour_minute_second) : nil),
    ((route.planning.customer.enable_orders ? (stop.order && stop.order.products.length > 0 ? stop.order.products.collect(&:code).join('/') : nil) : stop.visit.quantity) if stop.is_a?(StopVisit)),
    (l(stop.open, format: :hour_minute) if stop.open),
    (l(stop.close, format: :hour_minute) if stop.close),
    (stop.visit.tags.collect(&:label).join(',') if stop.is_a?(StopVisit))
  ]
}

if route.vehicle_usage && @export_stores
  csv << [
    route.ref || (route.vehicle_usage && route.vehicle_usage.vehicle.name),
    (route.vehicle_usage.vehicle.ref if route.vehicle_usage),
    index+1,
    I18n.t('plannings.export_file.stop_type_store'),
    nil,
    nil,
    (l(route.end, format: :hour_minute) if route.end),
    route.stop_distance,
    route.stop_drive_time,
    nil,
    nil,
    route.stop_out_of_drive_time ? 'x' : '',
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.ref,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.name,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.street,
    nil,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.postalcode,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.city,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.country,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.lat,
    route.vehicle_usage.default_store_stop && route.vehicle_usage.default_store_stop.lng,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil
  ]
end

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
class V01::Entities::Customer < Grape::Entity
  def self.entity_name
    'V01_Customer'
  end
  EDIT_ONLY_ADMIN = 'Only available in admin.'

  # expose(:reseller_id, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  # expose(:test, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:id, documentation: { type: Integer })
  expose(:end_subscription, documentation: { type: Date, desc: EDIT_ONLY_ADMIN })
  expose(:max_vehicles, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:take_over, documentation: { type: DateTime }) { |m| m.take_over && m.take_over.strftime('%H:%M:%S') }
  expose(:store_ids, documentation: { type: Integer, is_array: true })
  expose(:job_destination_geocoding_id, documentation: { type: Integer })
  expose(:job_store_geocoding_id, documentation: { type: Integer })
  expose(:job_optimizer_id, documentation: { type: Integer })
  expose(:ref, documentation: { type: String, desc: EDIT_ONLY_ADMIN })
  expose(:name, documentation: { type: String, desc: EDIT_ONLY_ADMIN })
  expose(:enable_orders, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_tomtom, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:tomtom_user, documentation: { type: String })
  expose(:tomtom_password, documentation: { type: String })
  expose(:tomtom_account, documentation: { type: String })
  expose(:enable_masternaut, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:masternaut_user, documentation: { type: String })
  expose(:masternaut_password, documentation: { type: String })
  expose(:router_id, documentation: { type: Integer })
  expose(:speed_multiplicator, documentation: { type: Float })
  expose(:default_country, documentation: { type: String })
  expose(:print_planning_annotating, documentation: { type: 'Boolean' })
  expose(:print_header, documentation: { type: String })
  expose(:enable_alyacom, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:alyacom_association, documentation: { type: String })
  expose(:profile_id, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:enable_references, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_multi_visits, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:optimization_cluster_size)
  # expose(:optimization_time)
  # expose(:optimization_soft_upper_bound)
end

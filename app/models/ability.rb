# Copyright © Mapotempo, 2013-2014
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

class Ability
  include CanCan::Ability
  def initialize(user = nil)
    if user
      if user.admin?
        can :manage, Customer, reseller_id: user.reseller_id
        can [:index, :new, :create], Customer
        can :manage, User, id: user.id
        can :manage, User, customer: {reseller_id: user.reseller_id}
        can [:index, :new, :create, :send_email], User
        can :manage, Reseller, id: user.reseller_id
        can [:index], Profile
      else
        can [:edit, :update, :password, :set_password], User, id: user.id
        can [:edit, :update], Customer, id: user.customer.id
        can [:stop_job_optimizer, :stop_job_destination_geocoding, :stop_job_store_geocoding], Customer
        can :manage, VehicleUsageSet, customer_id: user.customer.id
        can [:edit, :update, :toggle], VehicleUsage, vehicle_usage_set: {customer_id: user.customer.id}
        can :manage, Tag, customer_id: user.customer.id
        can [:new, :create], Tag
        can :manage, Destination, customer_id: user.customer.id
        can [:new, :create, :upload], Destination
        can :manage, Store, customer_id: user.customer.id
        can [:new, :create], Store
        can :manage, Zoning, customer_id: user.customer.id
        can [:new, :create], Zoning
        can :manage, Zone, zoning: {customer_id: user.customer.id}
        if !user.customer.end_subscription || user.customer.end_subscription > Time.now
          can :manage, Planning, customer_id: user.customer.id
          can [:new, :create], Planning
        end
        can :manage, Route, planning: {customer_id: user.customer.id}
        if user.customer.enable_orders
          can :manage, OrderArray, customer_id: user.customer.id
          can [:new, :create], OrderArray
          can :manage, Product, customer_id: user.customer.id
          can [:new, :create], Product
        end
      end
    else
      can [:password, :set_password], User
    end
  end
end

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
require 'test_helper'

class V01::Devices::AlyacomTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  require Rails.root.join("test/lib/devices/api_base")
  include ApiBase

  require Rails.root.join("test/lib/devices/alyacom_base")
  include AlyacomBase

  setup do
    @customer = add_alyacom_credentials customers(:customer_one)
  end

  test 'send' do
    with_stubs({ get: [:staff, :users, :planning], post: [:staff, :users, :planning] }) do
      set_route
      post api("devices/alyacom/send", { customer_id: @customer.id, route_id: @route.id })
      assert_equal 201, last_response.status
      @route.reload
      assert @route.reload.last_sent_at
      assert_equal({ "id" => @route.id, "last_sent_at" => @route.last_sent_at.iso8601(3) }, JSON.parse(last_response.body))
    end
  end

  test 'send multiple' do
    with_stubs({ get: [:staff, :users, :planning], post: [:staff, :users, :planning] }) do
      set_route
      post api("devices/alyacom/send_multiple", { customer_id: @customer.id, planning_id: @route.planning_id })
      assert_equal 201, last_response.status
      routes = @route.planning.routes.select(&:vehicle_usage)
      routes.each &:reload
      routes.each{|route| assert route.last_sent_at }
      assert_equal(routes.map{|route| { "id" => route.id, "last_sent_at" => route.last_sent_at.iso8601(3) } }, JSON.parse(last_response.body))
    end
  end

end

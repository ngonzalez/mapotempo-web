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
require 'csv'

class OrderArraysController < ApplicationController
  load_and_authorize_resource
  before_action :set_order_array, only: [:show, :edit, :update, :destroy, :duplicate]

  def index
    @order_arrays = current_user.customer.order_arrays
  end

  def show
    @visits_orders = @order_array.visits_orders
    planning = params.key?(:planning_id) ? current_user.customer.plannings.find(params[:planning_id]) : nil
    if planning
      i = -1
      visit_index = Hash[planning.routes.collect{ |route|
        route.stops.select{ |stop| stop.is_a?(StopVisit) }.collect{ |stop|
          [stop.visit.id, route.vehicle_usage]
        }
      }.flatten(1).collect{ |id, vehicle_usage| [id, [i += 1, vehicle_usage]] }]

      @visits_orders = @visits_orders.sort_by{ |visit_orders|
        visit_index[visit_orders[0].visit.id] ? visit_index[visit_orders[0].visit.id][0] : Float::INFINITY
      }.collect{ |visit_orders|
        [visit_orders, visit_index[visit_orders[0].visit.id][1]]
      }
    else
      @visits_orders = @visits_orders.collect{ |visit_orders|
        [visit_orders]
      }
    end

    respond_to do |format|
      format.html
      format.json do
      end
      format.excel do
        data = render_to_string.gsub('\n', '\r\n')
        send_data Iconv.iconv('ISO-8859-1//translit//ignore', 'utf-8', data).join(''),
            type: 'text/csv',
            filename: @order_array.name.delete('"') + '.csv'
      end
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="' + @order_array.name.delete('"') + '.csv"'
      end
    end
  end

  def new
    @order_array = current_user.customer.order_arrays.build
    @order_array.base_date = Date.today
  end

  def edit
  end

  def create
    respond_to do |format|
      OrderArray.transaction do
        @order_array = current_user.customer.order_arrays.build(order_array_params)
        @order_array.default_orders
        if @order_array.save
          format.html { redirect_to edit_order_array_path(@order_array), notice: t('activerecord.successful.messages.created', model: @order_array.class.model_name.human) }
        else
          format.html { render action: 'new' }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @order_array.update(order_array_params)
        format.html { redirect_to edit_order_array_path(@order_array), notice: t('activerecord.successful.messages.updated', model: @order_array.class.model_name.human) }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @order_array.destroy
    respond_to do |format|
      format.html { redirect_to order_arrays_url }
    end
  end

  def destroy_multiple
    OrderArray.transaction do
      if params['order_arrays']
        ids = params['order_arrays'].keys.collect{ |i| Integer(i) }
        current_user.customer.order_arrays.select{ |order_array| ids.include?(order_array.id) }.each(&:destroy)
      end
      respond_to do |format|
        format.html { redirect_to order_arrays_url }
      end
    end
  end

  def duplicate
    respond_to do |format|
      @order_array = @order_array.amoeba_dup
      @order_array.save!
      format.html { redirect_to edit_order_array_path(@order_array), notice: t('activerecord.successful.messages.updated', model: @order_array.class.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_array
    @order_array = OrderArray.find(params[:id] || params[:order_array_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_array_params
    params.require(:order_array).permit(:name, :base_date, :length)
  end
end

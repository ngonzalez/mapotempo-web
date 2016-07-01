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
require 'csv'
require 'importer_stores'
require 'font_awesome'

class StoresController < ApplicationController
  include LinkBack

  load_and_authorize_resource
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  before_action :icons_table
  after_action :warnings, only: [:create, :update]

  def index
    if current_user.customer.job_store_geocoding
      flash.now[:warning] = t('stores.geocoding.geocoding_in_progress')
    end
    @stores = current_user.customer.stores
    respond_to do |format|
      format.html
    end
  end

  def show
  end

  def new
    @store = current_user.customer.stores.build
    @store.postalcode = current_user.customer.stores[0].postalcode
    @store.city = current_user.customer.stores[0].city
  end

  def edit
  end

  def create
    @store = current_user.customer.stores.build(store_params)

    respond_to do |format|
      if current_user.customer.save
        format.html { redirect_to link_back || edit_store_path(@store), notice: t('activerecord.successful.messages.created', model: @store.class.model_name.human) }
      else
        flash.now[:error] = @store.customer.errors.full_messages if !@store.customer.errors.empty?
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      Store.transaction do
        if @store.update(store_params) && @store.customer.save
          format.html { redirect_to link_back || edit_store_path(@store), notice: t('activerecord.successful.messages.updated', model: @store.class.model_name.human) }
        else
          flash.now[:error] = @store.customer.errors.full_messages if !@store.customer.errors.empty?
          format.html { render action: 'edit' }
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if @store.destroy
        format.html { redirect_to stores_url }
      else
        format.html { redirect_to stores_path }
      end
    end
  end

  def destroy_multiple
    respond_to do |format|
      Store.transaction do
        if params['stores']
          ids = params['stores'].keys.collect{ |i| Integer(i) }
          current_user.customer.stores.select{ |store| ids.include?(store.id) }.each{ |store|
            if !store.destroy
              format.html { redirect_to stores_path and return }
            end
          }
        end
      end
      format.html { redirect_to stores_url }
    end
  end

  def import_template
    respond_to do |format|
      format.excel do
        data = render_to_string.gsub('\n', '\r\n')
        send_data Iconv.iconv('ISO-8859-1//translit//ignore', 'utf-8', data).join(''),
            type: 'text/csv',
            filename: 'import_template.csv'
      end
      format.csv
    end
  end

  def import
    @import_csv = ImportCsv.new
  end

  def upload_csv
    respond_to do |format|
      @import_csv = ImportCsv.new(import_csv_params.merge(importer: ImporterStores.new(current_user.customer)))
      if @import_csv.valid? && @import_csv.import
        format.html { redirect_to action: 'index' }
      else
        format.html { render action: 'import' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = current_user.customer.stores.find params[:id] || params[:store_id]
  end

  def warnings
    flash[:warning] = @store.warnings.join(', ') if @store.warnings && @store.warnings.any?
  end

  def icons_table
    @icons_table = FontAwesome::ICONS_TABLE
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:store).permit(:name, :street, :postalcode, :city, :country, :lat, :lng, :ref, :geocoding_accuracy, :geocoding_level, :color, :icon, :icon_size)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_csv_params
    params.require(:import_csv).permit(:replace, :file)
  end
end

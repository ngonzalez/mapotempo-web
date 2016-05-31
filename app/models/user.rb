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
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable

  nilify_blanks
  auto_strip_attributes :url_click2call

  belongs_to :reseller
  belongs_to :customer
  belongs_to :layer

  after_initialize :assign_defaults, if: 'new_record?'
  before_validation :assign_defaults_layer, if: 'new_record?'

  validates :customer, presence: true, unless: :admin?
  validates :layer, presence: true

  include RefSanitizer

  include Confirmable

  amoeba do
    enable

    customize(lambda { |original, copy|
      def copy.assign_defaults; end
      def copy.assign_defaults_layer; end
      def copy.generate_confirmation_token; end

      copy.email = I18n.l(Time.now, format: '%Y%m%d%H%M%S') + '_' + copy.email
      copy.password = Devise.friendly_token
      copy.confirmation_token = nil
    })
  end

  def admin?
    !reseller_id.nil?
  end

  def link_phone_number
    if self.url_click2call
      self.url_click2call
    else
      'tel:+{TEL}'
    end
  end

  def send_welcome_email
    Mapotempo::Application.config.delayed_job_use ? UserMailer.delay.welcome_message(self) : UserMailer.welcome_message(self).deliver_now
    self.update! confirmation_sent_at: Time.now
  end

  private

  def assign_defaults
    self.api_key ||= SecureRandom.hex
  end

  def assign_defaults_layer
    if admin?
      self.layer ||= Layer.order(:id).find_by!(overlay: false)
    else
      self.layer ||= customer && customer.profile.layers.order(:id).find_by!(overlay: false)
    end
  end
end

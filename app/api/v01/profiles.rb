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
class V01::Profiles < Grape::API
  resource :profiles do
    desc 'Fetch profiles.', {
      nickname: 'getProfiles',
      is_array: true,
      entity: V01::Entities::Profile
    }
    get do
      if @current_user.admin?
        present Profile.all, with: V01::Entities::Profile
      else
        error! 'Forbidden', 403
      end
    end

    desc 'Fetch routers in the profile', {
      nickname: 'getProfileRouters',
      is_array: true,
      entity: V01::Entities::Router
    }
    params {
      requires :id, type: Integer
    }
    get ':id/routers' do
      if @current_user.admin?
        profile = Profile.find(params[:id])
        present profile.routers.load, with: V01::Entities::Router
      else
        error! 'Forbidden', 403
      end
    end
  end
end
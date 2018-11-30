# Brimir is a helpdesk system to handle email support requests.
# Copyright (C) 2012-2016 Ivaldi https://ivaldi.nl/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class OmniauthController < Devise::OmniauthCallbacksController

  def camdram
    @auth = request.env['omniauth.auth']
    @user = User.from_omniauth(@auth)
    if @user.persisted?
      oauth_token = @auth['credentials'].token
      uri = URI("https://www.camdram.net/auth/account/organisations.json?access_token=#{oauth_token}")
      response = Net::HTTP.get_response(uri)
      raise "HTTP error" if !response == Net::HTTPSuccess
      societies = JSON.parse(response.body)
      societies.each do |soc|
        if soc["id"].to_s == "38" # Camdram meta-society ID
          @user.agent = true
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "Camdram") if is_navigational_format?
          return
        end
      end
      raise "Not a Camdram administrator"
    else
    end

  end

  def failure
    redirect_to root_url, alert: I18n.translate(:third_party_failure)
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end

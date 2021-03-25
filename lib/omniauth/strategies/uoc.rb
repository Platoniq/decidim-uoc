# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"

module OmniAuth
  module Strategies
    class Uoc < OmniAuth::Strategies::OAuth2
      args [:client_id, :client_secret, :site]

      option :name, :uoc
      option :site, nil
      option :client_options, {}

      uid do
        raw_info["sub"]
      end

      info do
        {
          email: raw_info["email"],
          nickname: raw_info["username"],
          name: raw_info["displayName"],
          locale: raw_info["preferredLanguage"],
          # image: raw_info["image"]
        }
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = URI.join(options.site, "/oauth2/auth").to_s
        options.client_options[:token_url] = URI.join(options.site, "/oauth2/token").to_s
        super
      end

      def raw_info
        @raw_info ||= access_token.get("/userinfo").parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

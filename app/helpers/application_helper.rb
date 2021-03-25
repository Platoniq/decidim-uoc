# frozen_string_literal: true

module ApplicationHelper
  def uoc?(user)
    user.identities.find_by(provider: "uoc").present?
  end

  def uoc_sign_in_enabled?
    Rails.application.secrets.omniauth.dig(:uoc, :enabled)
  end
end

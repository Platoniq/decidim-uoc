# frozen_string_literal: true

module ApplicationHelper
  def uoc?(user)
    user.identities.find_by(provider: "uoc").present?
  end
end

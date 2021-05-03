# frozen_string_literal: true

module ApplicationHelper
  def uoc?(user)
    user.identities.find_by(provider: OmniAuth::Strategies::Uoc::PROVIDER_NAME).present?
  end

  def uoc_sign_in_enabled?
    Rails.application.secrets.omniauth.dig(:uoc, :enabled)
  end

  def participatory_space_filters_form_url
    if request.path.remove("/").in?(
      [
        *AssembliesScoper.alternative_assembly_types.map { |hash| hash[:key] }
      ]
    )
      request.path
    else
      url_for
    end
  end
end

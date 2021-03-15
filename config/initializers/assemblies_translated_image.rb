# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Assemblies::AssemblyMCell.class_eval do
    private

    def resource_image_path
      custom_path = "uoc/assemblies/#{model.id}_#{I18n.locale}.jpg"
      return custom_path if Rails.application.assets.find_asset(custom_path).present?

      model.hero_image.url
    end
  end
end

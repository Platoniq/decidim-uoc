# frozen_string_literal: true

Rails.application.routes.draw do
  authenticated :user, ->(user) { user.admin? } do
    mount DelayedJobWeb, at: "/delayed_job"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  mount Decidim::Core::Engine => "/"

  # recreates the /assemblies route for /any-alternative, reusing the same controllers
  # content will be differentiatied automatically by scoping selectively all SQL queries depending on the URL prefix
  if Rails.application.secrets.alternative_assembly_types
    Rails.application.secrets.alternative_assembly_types.each do |item|
      resources item[:key], only: [:index, :show], param: :slug, path: item[:key], controller: "decidim/assemblies/assemblies" do
        resources :assembly_members, only: :index, path: "members"
        resource :assembly_widget, only: :show, path: "embed"
      end

      scope "/#{item[:key]}/:assembly_slug/f/:component_id" do
        Decidim.component_manifests.each do |manifest|
          next unless manifest.engine

          constraints Decidim::Assemblies::CurrentComponent.new(manifest) do
            mount manifest.engine, at: "/", as: "decidim_assembly_#{manifest.name}"
          end
        end
      end
    end
  end
end

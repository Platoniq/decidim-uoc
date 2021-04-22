# frozen_string_literal: true

# this middleware will detect by the URL if all calls to Assembly need to skip (or include) certain types
Rails.configuration.middleware.use AssembliesScoper

# tampers the Assembly model to put a default scope in all queries
# if configured previously
Rails.application.config.to_prepare do
  Decidim::Assembly.class_eval do
    class << self
      attr_accessor :scope_types, :scope_types_mode

      def scope_to_types(types, mode)
        self.scope_types = types
        self.scope_types_mode = mode
      end
    end

    def self.default_scope
      return unless scope_types

      case scope_types_mode
      when :exclude
        query = where("decidim_assemblies_type_id IS NULL OR decidim_assemblies_type_id NOT IN (?)", scope_types)
      when :include
        work_groups_type_ids = AssembliesScoper.alternative_assembly_types.find { |t| t[:key] = "work_groups" }[:assembly_type_ids]

        query = where(decidim_assemblies_type_id: scope_types)
        query = query.order(slug: :asc) if scope_types == work_groups_type_ids
      end

      query
    end
  end
end

Rails.application.config.after_initialize do
  # Creates a new menu next to Assemblies for every type configured
  AssembliesScoper.alternative_assembly_types.each do |item|
    Decidim.menu :menu do |menu|
      menu.item I18n.t(item[:key], scope: "uoc.alternative_assembly_types"),
                Rails.application.routes.url_helpers.send("#{item[:key]}_path"),
                position: item[:position_in_menu],
                if: Decidim::Assembly.unscoped.where(organization: current_organization, assembly_type: item[:assembly_type_ids]).published.any?,
                active: :inclusive
    end
  end
end

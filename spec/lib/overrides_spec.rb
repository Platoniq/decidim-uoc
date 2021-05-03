# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/views/decidim/admin/organization_appearance/form/_colors.html.erb" => "725fc77b4c80f885b7b4191a75a06949"
    }
  },
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/_logo.html.erb" => "2713715db652c8107f1fe5f2c4d618b6",
      "/app/views/layouts/decidim/_organization_colors.html.erb" => "34f0d188a62108e7a57a1c270daed8bb",
      # views
      "/app/views/decidim/account/show.html.erb" => "2e3c895104e03d7d092467a96f64703d",
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837",
      # oauth
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "05bc35af4b5f855736f14efbd22e439b",
      "/app/commands/decidim/create_omniauth_registration.rb" => "82b86ae7aa6a415383aad06cac80f1e9",
      "/app/forms/decidim/omniauth_registration_form.rb" => "ee09e2b5675c9d1cb4dc955dded05393"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      # just to take into the account if some routes change
      "/lib/decidim/assemblies/engine.rb" => "20d16ed292562a28198c5644426eb5d8",
      "/lib/decidim/assemblies/admin_engine.rb" => "5cb65ce77bd8bb2508984faa7825326f",
      "/app/models/decidim/assembly.rb" => "0d9726c3f40c320b02b31f59a70dbf02",
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda",
      "/app/views/decidim/assemblies/assemblies/_parent_assemblies.html.erb" => "fd026d4ee40dd1d5ebf8ad9ec5d0dbb4",
      "/app/cells/decidim/assemblies/assembly_m_cell.rb" => "701de343899341b472a84c03f2268092"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      # Change proposals title length limit
      "/app/forms/decidim/proposals/admin/proposal_form.rb" => "261a98a2d0a8df59c7dd2ce820458477"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end

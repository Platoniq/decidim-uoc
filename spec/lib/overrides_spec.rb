# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/views/decidim/admin/organization_appearance/form/_colors.html.erb" => "926acd42a72c91263042502bdf50b400"
    }
  },
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/_logo.html.erb" => "2713715db652c8107f1fe5f2c4d618b6",
      # views
      "/app/views/decidim/account/show.html.erb" => "2e3c895104e03d7d092467a96f64703d",
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      # just to take into the account if some routes change
      "/lib/decidim/assemblies/engine.rb" => "99a665d60c949c30a7f127c322dc3de5",
      "/lib/decidim/assemblies/admin_engine.rb" => "15bfba31a46f70870da42a07b588e59d",
      "/app/models/decidim/assembly.rb" => "b99256774db6151d5b0e47cacdbea550",
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda",
      "/app/views/decidim/assemblies/assemblies/_parent_assemblies.html.erb" => "fd026d4ee40dd1d5ebf8ad9ec5d0dbb4"
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

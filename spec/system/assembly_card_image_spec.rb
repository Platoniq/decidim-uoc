# frozen_string_literal: true

require "rails_helper"

describe "Assembly card images", type: :system do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
  end

  describe "translated assembly card image" do
    let(:src) { page.find("#assembly_#{assembly.id} .card__image")[:src] }

    context "when id and language match a custom image" do
      let!(:assembly) { create(:assembly, :published, organization: organization, id: 6) }

      before do
        visit decidim_assemblies.assemblies_path(locale: "ca")
      end

      it "shows the custom image in the card" do
        expect(src).to match("assets/uoc/assemblies/6_ca")
      end
    end

    context "when id and language don't match any custom image" do
      let!(:assembly) { create(:assembly, :published, organization: organization, id: 300) }

      before do
        visit decidim_assemblies.assemblies_path(locale: "ca")
      end

      it "shows the regular image in the card" do
        expect(src).to match("uploads/decidim/assembly/hero_image")
      end
    end
  end
end

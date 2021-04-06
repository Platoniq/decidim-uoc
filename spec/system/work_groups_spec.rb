# frozen_string_literal: true

require "rails_helper"

describe "Work groups order", type: :system do
  let(:organization) { create :organization }
  let!(:work_groups) { create :assemblies_type, id: 2, organization: organization }
  let!(:assemblies) do
    [
      create(:assembly, slug: "slug3", assembly_type: work_groups, organization: organization),
      create(:assembly, slug: "slug1", assembly_type: work_groups, organization: organization),
      create(:assembly, slug: "slug2", assembly_type: work_groups, organization: organization)
    ]
  end

  let(:route) { "work_groups" } # same as defined in secrets.yml!!
  let(:position) { 2.4 }
  let(:types) { [work_groups.id] }
  let(:alternative_assembly_types) do
    [
      {
        key: route,
        position_in_menu: position,
        assembly_type_ids: types
      }
    ]
  end

  before do
    switch_to_host(organization.host)
  end

  context "when visiting work_groups" do
    before do
      visit "/work_groups"
    end

    it "sorts assemblies by slug" do
      assembly_links = page.find_all(".card__link").map { |a| a[:href] }
      expect(assembly_links.count).to eq(3)
      expect(assembly_links[0]).to match("slug1")
      expect(assembly_links[1]).to match("slug2")
      expect(assembly_links[2]).to match("slug3")
    end
  end

  context "when visiting other assemblies" do
    let!(:other_assemblies) { create_list(:assembly, 3, organization: organization) }

    before do
      visit "/assemblies"
    end

    it "sorts assemblies by id" do
      assembly_links = page.find_all(".card__link").map { |a| a[:href] }
      expect(assembly_links.count).to eq(3)
      expect(assembly_links[0]).to match(other_assemblies[0].slug)
      expect(assembly_links[1]).to match(other_assemblies[1].slug)
      expect(assembly_links[2]).to match(other_assemblies[2].slug)
    end
  end
end

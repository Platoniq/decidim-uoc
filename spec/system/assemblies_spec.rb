# frozen_string_literal: true

require "rails_helper"

describe "Visit assemblies", type: :system do
  let(:organization) { create :organization }
  let!(:work_groups) { create :assemblies_type, id: 2 }
  let!(:type2) { create :assemblies_type }
  let!(:alternative_assembly) do
    create(
      :assembly,
      slug: "slug1",
      scope: scope_1,
      area: area_1,
      assembly_type: work_groups,
      organization: organization
    )
  end
  let!(:assembly) do
    create(
      :assembly,
      slug: "slug2",
      scope: scope_2,
      area: area_2,
      assembly_type: nil,
      organization: organization
    )
  end
  let!(:assembly2) do
    create(
      :assembly,
      slug: "slug3",
      scope: scope_2,
      area: area_2,
      assembly_type: type2,
      organization: organization
    )
  end
  let!(:scope_1) { create(:scope, organization: organization) }
  let!(:scope_2) { create(:scope, organization: organization) }
  let!(:area_1) { create(:area, organization: organization) }
  let!(:area_2) { create(:area, organization: organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when visiting home page" do
    before do
      visit decidim.root_path
    end

    it "shows the original assembly menu" do
      within ".main-nav" do
        expect(page).to have_content("Management")
        expect(page).to have_link(href: "/assemblies")
      end
    end

    it "shows the extra configured menu" do
      within ".main-nav" do
        expect(page).to have_content("Work groups")
        expect(page).to have_link(href: "/work_groups")
      end
    end

    context "and navigating to original assemblies" do
      before do
        within ".main-nav" do
          click_link "Management"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).not_to have_content(alternative_assembly.title["en"])
          expect(page).to have_content(assembly2.title["en"])
          expect(page).to have_content(assembly.title["en"])
        end
      end

      it "has the assemblies path" do
        expect(page).to have_current_path decidim_assemblies.assemblies_path
      end
    end

    context "and navigating to alternative assemblies" do
      before do
        within ".main-nav" do
          click_link "Work groups"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).to have_content(alternative_assembly.title["en"])
          expect(page).not_to have_content(assembly2.title["en"])
          expect(page).not_to have_content(assembly.title["en"])
        end
      end

      it "has the alternative path" do
        expect(page).to have_current_path work_groups_path
      end

      context "when filtering by scope" do
        before do
          within "#participatory-space-filters" do
            click_link "Select a scope"
          end
          within "#data_picker-modal" do
            click_link translated(scope_1.name)
            click_link "Select"
          end
        end

        it "show alternative processes when filtering" do
          within "#parent-assemblies" do
            expect(page).to have_content(alternative_assembly.title["en"])
            expect(page).not_to have_content(assembly2.title["en"])
            expect(page).not_to have_content(assembly.title["en"])
          end
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(work_groups_path))
        end
      end

      context "when filtering by area" do
        before do
          within "#participatory-space-filters" do
            select "Select an area"
            select translated(area_1.name)
          end
        end

        it "show alternative processes when filtering" do
          within "#parent-assemblies" do
            expect(page).to have_content(alternative_assembly.title["en"])
            expect(page).not_to have_content(assembly2.title["en"])
            expect(page).not_to have_content(assembly.title["en"])
          end
        end

        it "has the alternative path" do
          expect(page).to have_current_path(Regexp.new(work_groups_path))
        end
      end
    end
  end

  context "when accessing original assemblies with an alternative path" do
    before do
      visit "/work_groups/#{assembly2.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly2.slug)
    end
  end

  context "when accessing alternative assemblies with the original path" do
    before do
      visit "/assemblies/#{alternative_assembly.slug}"
    end

    it "redirects to the alternative path" do
      expect(page).to have_current_path work_group_path(alternative_assembly.slug)
    end
  end

  context "when accessing non typed assemblies with the alternative path" do
    before do
      visit "/work_groups/#{assembly.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly.slug)
    end
  end

  describe "work groups order" do
    context "when visiting work_groups" do
      let!(:assemblies) do
        [
          alternative_assembly,
          create(:assembly, slug: "workgroup3", assembly_type: work_groups, organization: organization),
          create(:assembly, slug: "workgroup1", assembly_type: work_groups, organization: organization),
          create(:assembly, slug: "workgroup2", assembly_type: work_groups, organization: organization)
        ]
      end

      before do
        visit "/work_groups"
      end

      it "sorts assemblies by slug" do
        assembly_links = page.find_all(".card__link").map { |a| a[:href] }
        expect(assembly_links.count).to eq(4)
        expect(assembly_links[0]).to match("slug1")
        expect(assembly_links[1]).to match("workgroup1")
        expect(assembly_links[2]).to match("workgroup2")
        expect(assembly_links[3]).to match("workgroup3")
      end
    end
  end
end

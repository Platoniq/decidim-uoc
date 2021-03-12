# frozen_string_literal: true

require "rails_helper"
require "byebug"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:work_groups) { create :assemblies_type, id: 2 }

  before do
    switch_to_host(organization.host)
  end

  it "renders the home page" do
    visit decidim.root_path

    within ".main-nav" do
      expect(page).to have_content("Home")
      expect(page).not_to have_content("Management")
      expect(page).not_to have_content("Work groups")
    end
  end

  context "when there is normal assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Management")
        expect(page).not_to have_content("Work groups")
      end
    end
  end

  context "when there is alternative assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }
    let!(:assembly2) { create(:assembly, :published, assembly_type: work_groups, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Home")
        expect(page).to have_content("Management")
        expect(page).to have_content("Work groups")
      end
    end
  end

  describe "logo" do
    let(:src) { page.find(".logo-wrapper img")[:src] }

    shared_examples_for "translated logo" do
      it "loads correct src" do
        visit decidim.root_path(locale: locale)
        expect(src).to match "logo_#{locale}"
      end
    end

    context "when locale is 'ca'" do
      let(:locale) { "ca" }

      it_behaves_like "translated logo"
    end

    context "when locale is 'en'" do
      let(:locale) { "en" }

      it_behaves_like "translated logo"
    end

    context "when locale is 'es'" do
      let(:locale) { "es" }

      it_behaves_like "translated logo"
    end
  end

  it "has matomo tracker" do
    expect(page.execute_script("return typeof window._paq")).not_to eq("undefined")
    expect(page.execute_script("return typeof window._paq")).to eq("object")
  end
end

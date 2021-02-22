# frozen_string_literal: true

require "rails_helper"
require "byebug"

describe "Visit the home page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
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

  # it "has matomo tracker" do
  #   expect(page.execute_script("return typeof window._paq")).not_to eq("undefined")
  #   expect(page.execute_script("return typeof window._paq")).to eq("object")
  # end
end

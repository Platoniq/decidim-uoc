# frozen_string_literal: true

require "rails_helper"

describe "Visit the login page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:user) { create :user, :confirmed, organization: organization }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  it "renders the login page" do
    expect(page).to have_content("Log in")
  end

  it "doesn't show email and password login by default" do
    expect(page).not_to have_selector("#session_user_email")
    expect(page).not_to have_selector("#session_user_password")
  end

  context "when clicking on 'Enter with another account'" do
    before do
      page.find(".alternative-login a").click
    end

    it "shows email and password login" do
      expect(page).to have_selector("#session_user_email")
      expect(page).to have_selector("#session_user_password")
    end
  end
end

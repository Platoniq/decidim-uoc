# frozen_string_literal: true

require "rails_helper"

describe "Visit the account page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:user) { create :user, :confirmed, organization: organization }

  before do
    switch_to_host(organization.host)
    sign_in user, scope: :user
    visit decidim.account_path
  end

  it "renders the account page" do
    expect(page).to have_content("My account")
  end

  context "when user does not have a 'uoc' identity" do
    it "has regular fields" do
      expect(page).to have_selector("input#user_name")
      expect(page).to have_selector("input#user_nickname")
      expect(page).to have_selector("input#user_email")
    end

    it "has no readonly fields" do
      expect(page).not_to have_selector("input#user_name[readonly]")
      expect(page).not_to have_selector("input#user_nickname[readonly]")
      expect(page).not_to have_selector("input#user_email[readonly]")
    end

    it "has no callout message" do
      expect(page).not_to have_content("cannot be edited")
    end
  end

  context "when user has a 'uoc' identity" do
    let!(:identity) { create(:identity, user: user, provider: Omniauth::Strategies::Uoc::PROVIDER_NAME) }

    before do
      visit decidim.account_path
    end

    it "has readonly fields" do
      expect(page).to have_selector("input#user_name[readonly]")
      expect(page).to have_selector("input#user_nickname[readonly]")
      expect(page).to have_selector("input#user_email[readonly]")
    end

    it "has callout message" do
      within ".callout" do
        expect(page).to have_content("cannot be edited")
      end
    end
  end
end

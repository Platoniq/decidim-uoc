# frozen_string_literal: true

require "rails_helper"

describe Decidim::Proposals::Admin::ProposalForm do
  subject { form }

  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:participatory_space) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, manifest_name: "proposals", participatory_space: participatory_space) }
  let(:max_length) { 300 }
  let(:title) { { en: "Words " * (max_length / "Words ".length) } }
  let(:long_title) { { en: "A whole lot of words " * 15 } }
  let(:body) { { en: "Everything would be better" } }
  let(:author) { create(:user, organization: organization) }
  let(:category) { create(:category, participatory_space: participatory_space) }
  let(:parent_scope) { create(:scope, organization: organization) }
  let(:scope) { create(:subscope, parent: parent_scope) }
  let(:category_id) { category.try(:id) }
  let(:scope_id) { scope.try(:id) }
  let(:meeting_as_author) { false }
  let(:params) do
    {
      title: title,
      body: body,
      author: author,
      category_id: category_id,
      scope_id: scope_id,
      has_address: false,
      meeting_as_author: meeting_as_author
    }
  end

  let(:form) do
    described_class.from_params(params).with_context(
      current_component: component,
      current_organization: component.organization,
      current_participatory_space: participatory_space
    )
  end

  context "when everything is OK" do
    it { is_expected.to be_valid }
  end

  context "when the title is too long" do
    let(:title) { long_title }

    it { is_expected.to be_invalid }
  end
end

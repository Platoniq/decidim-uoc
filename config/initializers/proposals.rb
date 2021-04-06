# frozen_string_literal: true

Decidim::Proposals.configure do |config|
  config.similarity_threshold = 0.99
  config.similarity_limit = 2
end

class AddUocAffiliationsToDecidimUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :uoc_oauth_data, :jsonb
  end
end

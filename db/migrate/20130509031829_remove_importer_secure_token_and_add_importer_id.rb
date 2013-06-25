class RemoveImporterSecureTokenAndAddImporterId < ActiveRecord::Migration
  def up
    remove_column :importers, :secure_token

    remove_column :companies, :importer_secure_token
    add_column :companies, :importer_id,:integer

    remove_column :company_clients, :importer_secure_token
    add_column :company_clients, :importer_id,:integer


    add_column :data_sources, :importer_id, :integer
    add_column :data_items, :importer_id, :integer

    remove_column :client_company_relationships, :importer_secure_token
    add_column :client_company_relationships, :importer_id, :integer

    remove_column :client_person_relationships, :importer_secure_token
    add_column :client_person_relationships, :importer_id, :integer

  end

  def down
    add_column :importers, :secure_token,:string

    add_column :companies, :importer_secure_token,:string
    remove_column :companies, :importer_id

    add_column :company_clients, :importer_secure_token,:string
    remove_column :company_clients, :importer_id


    remove_column :data_sources, :importer_id
    remove_column :data_items, :importer_id

    add_column :client_company_relationships, :importer_secure_token,:string
    remove_column :client_company_relationships, :importer_id

    add_column :client_person_relationships, :importer_secure_token,:string
    remove_column :client_person_relationships, :importer_id
  end
end

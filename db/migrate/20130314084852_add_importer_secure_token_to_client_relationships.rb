class AddImporterSecureTokenToClientRelationships < ActiveRecord::Migration
  def change

    add_column :client_company_relationships, :importer_secure_token, :string
    add_column :client_person_relationships, :importer_secure_token, :string

  end
end

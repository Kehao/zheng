class CreateClientCompanyRelationships < ActiveRecord::Migration
  def change
    create_table :client_company_relationships do |t|
      t.references :client, polymorphic: true
      t.references :company
      t.text       :desc

      t.timestamps
    end
  end
end

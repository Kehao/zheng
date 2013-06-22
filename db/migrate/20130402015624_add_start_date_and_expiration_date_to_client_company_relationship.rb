class AddStartDateAndExpirationDateToClientCompanyRelationship < ActiveRecord::Migration
  def change
    add_column :client_company_relationships, :start_date, :date
    add_column :client_company_relationships, :expiration_date, :date

    add_column :client_person_relationships, :start_date, :date
    add_column :client_person_relationships, :expiration_date, :date
  end
end

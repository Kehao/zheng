class AddRelateTypeToClientRelationships < ActiveRecord::Migration
  def change
    add_column :client_company_relationships, :relate_type,  :integer, :null => false
    add_column :client_company_relationships, :hold_percent, :float

    add_column :client_person_relationships, :relate_type,  :integer, :null => false
    add_column :client_person_relationships, :hold_percent, :float
  end
end

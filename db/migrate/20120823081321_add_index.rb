class AddIndex < ActiveRecord::Migration
  def change
    add_index :companies,                     :name,                       unique: true
    add_index :companies,                     :number,                     unique: true
    add_index :companies,                     :owner_id

    add_index :people,                        :number,                     unique: true

    add_index :certs,                         :company_id,                 unique: true


    add_index :user_seeks,                    :user_id

    add_index :company_clients,               :user_id

    add_index :person_clients,                :user_id

    add_index :company_crimes,                :company_id

    add_index :person_crimes,                 :person_id

    add_index :client_company_relationships,  [:client_id, :client_type]

    add_index :client_person_relationships,   [:client_id, :client_type]

    add_index :list_files,                    :user_id
    add_index :list_files,                    :import_status


    # add_index :spiders, [:sponsor_id, :sponsor_type] # 在add_index_to_spiders里已经增加
    # add_index :spiders, :status 
    
    # add_index :crimes, [:party_id, :party_type]  # 删除party_id, party_type属性
  end
end

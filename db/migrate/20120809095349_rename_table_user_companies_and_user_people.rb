class RenameTableUserCompaniesAndUserPeople < ActiveRecord::Migration
  def change
    rename_table :user_companies, :company_clients
    rename_table :user_people,    :person_clients
  end
end

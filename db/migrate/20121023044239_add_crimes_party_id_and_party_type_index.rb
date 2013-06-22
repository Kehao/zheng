class AddCrimesPartyIdAndPartyTypeIndex < ActiveRecord::Migration
  def change
    add_index :crimes, [:party_id, :party_type]
  end
end

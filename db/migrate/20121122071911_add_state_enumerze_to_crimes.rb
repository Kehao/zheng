class AddStateEnumerzeToCrimes < ActiveRecord::Migration
  def change
    add_column :crimes, :state, :integer
  end
end

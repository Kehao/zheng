class AddRegDateToCrime < ActiveRecord::Migration
  def up
    add_column :crimes, :regist_date, :date
    Crime.find_each do |c|
      begin
        date = Date.parse c.reg_date
        c.update_attributes regist_date: date
      rescue Exception => ex
        puts "bad date format was found @ crime - #{c.id}."
      end
    end
  end

  def down
    remove_column :crimes, :regist_date
  end

end

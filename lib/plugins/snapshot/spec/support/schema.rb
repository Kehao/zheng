require 'active_record'

ActiveRecord::Base.establish_connection(
   adapter: 'mysql2',
  encoding: 'utf8',
  reconnect: false,
  database: 'skyeye_test',
  pool: 25,
  username: "root",
  password: "admin123",
  socket: "/var/run/mysqld/mysqld.sock"
)
class Crime < ActiveRecord::Base
  attr_accessible :party_name, 
                  :party_number, 
                  :case_id, 
                  :case_state, 
                  :reg_date,
                  :regist_date, 
                  :apply_money, 
                  :court_name, 
                  :card_number, 
                  :orig_url

end

class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
      t.string :party_name       # 当事人名字(当事人：公司/个人)
      t.string :party_number     # 当事人号码(身份证号，机构号)
      t.string :case_id          # 案件号(唯一)
      t.string :case_state       # 案件状态
      t.string :reg_date         # 立案时间
      t.string :apply_money      # 执行标的
      t.string :court_name       # 执行法院

      t.references :party, polymorphic: true
      
      t.timestamps
    end
  end
end

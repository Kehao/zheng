class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string    :sales_area

      t.integer   :worker_number_of_this_year
      t.integer   :worker_number_of_last_year
      t.integer   :worker_number_of_the_year_before_last

      t.float     :income_of_this_year
      t.float     :income_of_last_year
      t.float     :income_of_the_year_before_last

      t.float     :assets_of_this_year
      t.float     :assets_of_last_year
      t.float     :assets_of_the_year_before_last


      t.float     :debt_of_this_year
      t.float     :debt_of_last_year
      t.float     :debt_of_the_year_before_last

      t.float     :profit_of_this_year
      t.float     :profit_of_last_year
      t.float     :profit_of_the_year_before_last


      t.float     :order_amount_of_this_year
      t.float     :order_amount_of_last_year
      t.float     :order_amount_of_the_year_before_last


      t.float     :vat_of_this_year
      t.float     :vat_of_last_year
      t.float     :vat_of_the_year_before_last


      t.float     :income_tax_of_this_year
      t.float     :income_tax_of_last_year
      t.float     :income_tax_of_the_year_before_last

      t.float     :elec_charges_monthly_of_this_year   # 元
      t.float     :elec_charges_monthly_of_last_year
      t.float     :elec_charges_monthly_of_the_year_before_last

      t.float     :water_charges_monthly_of_this_year  # 元
      t.float     :water_charges_monthly_of_last_year  # 元
      t.float     :water_charges_monthly_of_the_year_before_last

      t.float     :major_income_of_this_year
      t.float     :major_income_of_last_year
      t.float     :major_income_of_the_year_before_last

      t.references :company 
      t.timestamps
    end
  end
end
#worker_number: 公司员工数
#sales_area: 销售所在地
#income_of_last_year: 去年销售收入
#income_of_the_year_before_last: 前年销售收入
#assets_of_last_year: 去年资产总额
#assets_of_the_year_before_last: 前年资产总额
#debt_of_last_year: 去年负债总额
#debt_of_the_year_before_last: 前年负债总额
#profit_of_last_year: 去年利润总额
#profit_of_the_year_before_last: 前年利润总额
#income_of_this_year: 截止上月销售
#order_amount_of_this_year: 当年订单总额
#order_amount_of_last_year: 去年订单总额
#vat_of_last_year: 去年vat总额
#income_tax_of_last_year: 去年所得税
#elec_charges_monthly_of_this_year: 当年月均电费
#elec_charges_monthly_of_last_year: 去年月均电费
#water_charges_monthly_of_this_year: 当年月均水费
#water_charges_monthly_of_last_year: 去年月均水费
#major_income_by_year: 当年主营收入

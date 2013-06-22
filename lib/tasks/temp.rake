#encoding: utf-8
require 'csv'
namespace :data do
  task :import_bjgs, [:path] => [:environment] do |t, args|
    csv = CSV.read(args.path, headers: true)
    csv.each do |row|
      cert_attrs = {
        regist_id:           row["reg_id"],
        company_type:        row["company_type"],
        name:                row["name"],
        owner_name:          row["owner_name"],
        found_date:          row["found_date"],
        regist_capital:      row["reg_capital_currency"],
        business_start_date: row["start_date"],
        business_end_date:   row["end_date"],
        regist_org:          row["reg_org"],
        address:             row["address"],
        business_scope:      row["business_scope"],
        check_years:         row["check_years"]
      }
      Company.create_with_cert(cert_attrs)
    end
  end

  task :repaire_company_type, [:path] => [:environment] do |t, args|
    csv = CSV.read(args.path, headers: true)
    csv.each do |row|
      if cert = Cert.find_by_name(row["name"])
        cert.update_attributes(company_type: row["category"])
      end
    end
  end

  task :update_regist_capital_amount => [:environment] do
    Cert.find_each do |cert|
      cert.regist_capital = cert.regist_capital
      cert.save
    end
  end

  task :loading_rand_rank => [:environment] do
    regist_capital_arr = Cert.all.map(&:regist_capital).compact.map(&:to_i).compact
    puts "arr count is #{regist_capital_arr.count}"
    Company.find_each do |c|
      if c.cert.present? 
        c.create_business if c.business.nil?
        b = c.business
        if b.scale.blank?
          ci = c.cert.regist_capital.to_i
          rank = regist_capital_arr.find_all{|i| i > ci}.count + 1
          b.scale = rank
          b.save
        end
      end
    end
  end

  task :loading_credit_rank => [:environment] do
    credit_arr = Company.all.map{|c| c.all_crimes.count}
    puts "arr count is #{credit_arr.count}"
    Company.find_each do |c|
      c.create_business if c.business.nil?
      b = c.business
      if c.business.credit.blank? || true
        cnt  = c.all_crimes.count
        rank = credit_arr.find_all{|i| i < cnt}.count + 1
        b.credit = rank
        b.save
      end
    end
  end

  task :loading_sales_rank => [:environment] do
    sales_arr = Business.all.map(&:income_of_last_year).compact
    puts "arr count is #{sales_arr.count}"
    Business.all.each do |b|
      if b.sales.blank? && b.income_of_last_year
        rank = sales_arr.find_all{|i| i > b.income_of_last_year}.count + 1
        b.sales = rank
        b.save
      end
    end
  end

  task :loading_profit_rank => [:environment] do
    profit_arr = Business.all.map(&:profit_of_last_year).compact
    puts "arr count is #{profit_arr.count}"
    Business.all.each do |b|
      if b.profit.blank? && b.profit_of_last_year
        rank = profit_arr.find_all{|i| i > b.profit_of_last_year}.count + 1
        b.profit = rank
        b.save
      end
    end
  end
end
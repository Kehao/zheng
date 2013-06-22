module Skyeye
  mattr_accessor :log_stdout
  class << self
    def safe_call(name, message = nil)
      puts "==========================="
      puts message || name
      puts "==========================="
      self.send(name)
      puts "=== done"
    rescue Exception => ex
      puts "*** transaction abored!"
      puts "*** errors: #{ex.message}"
    end
    
    def init
      ActiveRecord::Base.transaction do      
        User.destroy_all
        Role.destroy_all
        Institution.destroy_all
        Industry.destroy_all
        init_role
        init_institution
        init_industry
        init_user
      end
    end

    def init_institution
      puts "=== init institution"
      KeyValues::Institution.all.each do |institution|
        ins = Institution.new(institution.attributes)
        ins.save!
      end
    end

    def init_industry
      puts "=== init industry"
      KeyValues::Industry.all.each do |industry|
        ind = Industry.new(industry.attributes)
        ind.send :write_attribute, :id, industry.attributes[:id]
        ind.save!
      end
    end

    def init_role
      puts "=== init role"
      create_default_roles
    end

    def init_user
      puts "=== init user"
      create_admin
    end

    def create_default_roles
      unless Role.where(name:"admin").first
        KeyValues::Role.all.each do |role|
          r = Role.new(role.attributes)
          r.send :write_attribute, :id, role.attributes[:id]
          r.save!

          a = Capability.new(role.ability.attributes)
          a.send :write_attribute, :id, role.ability.attributes[:id]
          a.save!
        end
      end
    end

    def create_admin
      User.create!({
        name:  'admin', 
        email: 'admin@example.com',
        password: 'password',
        password_confirmation: 'password',
        role_id: 100000,
        institution_id: 1
      })
    end

    def once_log_stdout
      if self.log_stdout 
        logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = Logger.new(STDOUT)
        yield
        ActiveRecord::Base.logger = logger
        self.log_stdout = false
      else
        yield
      end
    end

    def reset_company_power_account_count
      if Skyeye::plugins.find_by_name("skyeye_power")
        self.log_stdout = true
        Company.find_each do |c|
          once_log_stdout do
            Company.reset_counters(c.id, :water_company_accounts, :elec_company_accounts)
          end
        end
      end
    end
  end
end

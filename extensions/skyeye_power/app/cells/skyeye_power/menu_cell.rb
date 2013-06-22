module SkyeyePower
  class MenuCell < Cell::Rails
    helper Rails.application.helpers

    def admin(args = {})
      render
    end

    def global(args = {})
      @args=args
      render
    end 

    def admin_company(args = {})
      @company = args[:company]
      render
    end 

    def company_list(args = {})
    end 

    def company(args = {})
    end 

    def company_client_list(args = {})
      user    = args[:current_user]
      ability = args[:current_ability] 

      render
    end 

    def company_client(args = {})
      @company_client = args[:company_client]

      render
    end 

    def company_client_list_exception(args = {})
      user    = args[:current_user]
      ability = args[:current_ability] 

      render
    end 
  end
end

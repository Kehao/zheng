module Workflow
  class MenuCell < Cell::Rails
    helper Rails.application.helpers
    def form(args = {})
      @current_user=args[:current_user]
      @trackable=args[:trackable]
      @f=args[:f]
      render
    end

    def admin(args = {})
      render
    end

    def global(args = {})
      render
    end 
  end
end

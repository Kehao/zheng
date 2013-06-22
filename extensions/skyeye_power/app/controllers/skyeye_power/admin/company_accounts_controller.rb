#encoding: utf-8
module SkyeyePower
  module Admin
    class CompanyAccountsController < ApplicationController
      respond_to :json,:html,:xml

      expose(:company) do
        SkyeyePower.company_class.find(params[:company_id])
      end
      #      expose(:resources) {:company_accounts}

      def index
        @accounts = company.send resources
      end

      def create
        @account = company.send(resources).new(params[resources.to_s.singularize])
        @account.author=current_user
        respond_with(@account) do |format|
          if @account.save
            format.html { redirect_to [:admin,company,resources], notice: '账户新建成功' }
          else
            format.html { redirect_to [:admin,company,resources], alert:"账户新建失败:#{@account.errors.full_messages.join(',')}" }
          end
        end    
      end

      def update
        @account = company.send(resources).find(params[:id])

        respond_with(@account) do |format|
          if @account.update_attributes(params[resources.to_s.singularize])
            format.html { redirect_to [:admin,company,resources], notice: '账户修改成功' }
          else
            format.html { redirect_to [:admin,company,resources], alert: "账户修改失败:#{@account.errors.full_messages.join(',')}" }
          end
        end
      end

      def destroy
        @account = company.send(resources).find(params[:id])
        @account.destroy
        redirect_to [:admin,company,resources]
      end
    end
  end
end

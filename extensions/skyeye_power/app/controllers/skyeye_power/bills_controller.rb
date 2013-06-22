#encoding: utf-8
module SkyeyePower
  class BillsController < ApplicationController
    layout false
    expose :company_account do
      SkyeyePower::CompanyAccount.find(params[:water_company_account_id]||params[:elec_company_account_id])
    end

    def index
      @bills = company_account.bills.order("created_at DESC").page(params[:page])
      respond_to do |f|
        f.js 
        f.html
      end
    end

    def new
      @bill = company_account.bills.new
      respond_to do |f|
        f.js { render :edit}
      end
    end

    def edit
      @bill = company_account.bills.find(params[:id])
      respond_to do |f|
        f.js
      end
    end

    def create
      @bill = company_account.bills.new(params[:bill])
      respond_to do |f|
        if @bill.save
          f.js {render :index}
        else
          f.js {render :edit}
        end
      end
    end

    def update
      @bill = company_account.bills.find(params[:id])
      respond_to do |f|
        if @bill.update_attributes(params[:bill])
          f.js {render :index}
        else
          f.js {render :edit}
        end
      end
    end

    def destroy
      bill = company_account.bills.find(params[:id])
      if bill.destroy
        render :js => "$(\"##{dom_id(bill)}\").remove();"
      end
    end
  end
end

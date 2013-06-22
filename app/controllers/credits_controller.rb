class CreditsController < ApplicationController
  def edit
    @credit = Credit.find(params[:id])
    @company = @credit.company
    @company_client = current_user.company_clients.find_by_company_id(@company.id)

    (4 - @credit.operators.count).times{ @credit.operators.build }
    (5 - @credit.equips.count).times{ @credit.equips.build }
    (5 - @credit.loans.count).times{ @credit.loans.build }
    (5 - @credit.morts.count).times{ @credit.morts.build }
    (3 - @credit.holder_changes.count).times{ @credit.holder_changes.build }
    (3 - @credit.mass_changes.count).times{ @credit.mass_changes.build }
  end

  def update
    @credit = Credit.find(params[:id])
    @company = @credit.company
    @company_client = current_user.company_clients.find_by_company_id(@company.id)

    @credit.update_attributes(params[:credit])
    redirect_to @company_client
  end
end

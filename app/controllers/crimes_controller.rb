class CrimesController < ApplicationController
  def index
    q = params[:q]
    attrs = %w{crimes.updated_at name reg_date case_state apply_money party_number court_name case_id apply_money}
    @crimes = current_user.companies.joins(:crimes).select(attrs)

    if q.present?
      convert_date_param!(params[:q], :start_from )

      c = q["closed"].to_i == 1 ? "(crimes.state = 1)" : nil
      o = q["other"].to_i  == 1 ? "(crimes.state != 1 and crimes.state != 2)" : nil
      p = q["processing"].to_i == 1 ? "(crimes.state = 2)" : nil
      stats_where = [c, o, p].compact.join(" or ")
      @crimes = @crimes.where(stats_where) if stats_where.present?

      start_from_where = ["crimes.regist_date >= ?", params[:q]["start_from"]]
      @crimes = @crimes.where(start_from_where) if start_from_where.present?

      floor_where = ["crimes.apply_money >= ?", params[:q]["floor"].to_i] if params[:q]["floor"].present?
      @crimes = @crimes.where(floor_where) if floor_where.present?

      upper_where = ["crimes.apply_money <= ?", params[:q]["upper"].to_i] if params[:q]["upper"].present?
      @crimes = @crimes.where(upper_where) if floor_where.present?
    end

    t = params[:target]
    if t.present?
      @crimes = @crimes.where(crimes: {party_type: t}) 
    end

    @crimes = @crimes.page(params[:page])
  end

  private
  def convert_date_param!(attrs, name)
    attrs[name] = Date.civil(
      attrs.delete("#{name}(1i)").to_i,  
      attrs.delete("#{name}(2i)").to_i,  
      attrs.delete("#{name}(3i)").to_i  
    )
  end
end

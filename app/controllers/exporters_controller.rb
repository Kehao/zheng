#encoding: utf-8
class ExportersController < ApplicationController
  # load_and_authorize_resource through: :current_user

  def index
    @exporters = current_user.exporters.order("created_at DESC").page(params[:page])
    @new_exporter = current_user.exporters.new
  end

  def show
    @exporter = Exporter.find(params[:id])
    send_file "#{@exporter.absolute_file_path}"
  end

  def create
    @exporter = current_user.exporters.create(params_exporter)
    @exporter.export
    if @exporter.status == 'success'
      flash[:success] = "导出成功"
    elsif @exporter.status == 'failed'
      flash[:error] = "导出失败，可能没有案件信息"
    end
    @exporters = current_user.exporters.order("created_at DESC").page(params[:page])
    redirect_to exporters_path(:tab => params[:tab])
  end

  def destroy
    @exporter = Exporter.find(params[:id])
    @exporter.destroy
    respond_to do |f|
      f.js   { head :no_content}
      f.html { redirect_to exporters_path }
    end
  end

  private
  def convert_date(options,attr_name)
    if options && options["#{attr_name}(1i)"]
      year  = options.delete("#{attr_name}(1i)").to_i
      month = options.delete("#{attr_name}(2i)").to_i
      day   = options.delete("#{attr_name}(3i)").to_i
      options[attr_name.intern] = Date.civil(year, month, day)
    end
  end

  def params_exporter
    attrs = params[:exporter].dup

    attrs[:options].delete("region_name")

    if attrs[:options][:relationship_attrs]
      relate_type_in = attrs[:options][:relationship_attrs][:relate_type_in]
      attrs[:options][:relationship_attrs][:relate_type_in] = relate_type_in.map do |ty| 
        ClientRelationship::RELATE_TYPES[ty.intern]
      end
    end

    convert_date(attrs[:options],"regist_date_after")
    convert_date(attrs[:options][:crime_attrs],"regist_date_after")
    convert_date(attrs[:options][:client_attrs],"created_at_from")
    convert_date(attrs[:options][:client_attrs],"created_at_to")

    attrs
  end
end

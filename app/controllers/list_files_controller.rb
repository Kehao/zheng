#encoding: utf-8
class ListFilesController < ApplicationController
  def create
    if params[:list_file]
      @list_file = current_user.list_files.build(params[:list_file])
      @list_file.name = params[:list_file][:clients_list].original_filename
      if @list_file.save
        flash[:notice] = "上传成功，开始解析和载入；"
      else
        flash[:alert] = "文件发现问题，请查看文件格式和内容；"
      end
    else
      flash[:alert] = "无法检测到文件，请检查您已添加文件，文件格式和内容；"
    end
    
    respond_to do |f|
      f.html { redirect_to new_company_client_path }
      f.js 
      f.json { render json: @list_file }
    end
  end

  def destroy
    @list_file = ListFile.find(params[:id])
    if params[:delete_relevant_clients].present?
      @list_file.company_clients.each{|cc| cc.destroy}
      flash[:notice] = "删除了一个列表文件，保留了对应的相关客户；"
    end
    if @list_file.destroy
      flash[:notice] ||= "删除了一个列表文件，并删除了对应的相关客户；"
    else
      flash[:alert] = "有问题，请重试；"
    end
    redirect_to new_company_clients_path
  end
end

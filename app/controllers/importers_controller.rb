#encoding: utf-8
class ImportersController < ApplicationController
  def create
    if params[:importer] && params[:importer][:file]
      import_class_string = params[:importer].delete(:class)
      @importer = import_class_string.constantize.new(params[:importer])
      @importer.user = current_user
      @importer.name = params[:importer][:file].original_filename
      @importer.secure_token = @importer.file.send :secure_token

      if @importer.save
        flash[:notice] = "上传成功，开始解析和载入；"
      else
        flash[:alert] = "文件发现问题，请查看文件格式和内容；"
      end
    else
      flash[:alert] = "无法检测到文件，请检查您已添加文件，文件格式和内容；"
    end

    respond_to do |f|
      f.html { redirect_to params[:redirect_to] }
      f.js 
      f.json { render json: @importer }
    end

  end

  def import_temp
    @temp = ImporterExceptionTemp.find(params[:temp_id])

    respond_to do |f|
      if @temp.importer.import_row_with_pre_valid(@temp.data)
        @temp.destroy
        f.js {render :import_temp}
      else
        @temp.exception_msg = @temp.importer.row_exception_msgs
        @temp.save
        f.js {render :update_importer_temp}
      end
    end

  end

  def update_importer_temp
    @temp = ImporterExceptionTemp.find(params[:temp_id])
    @temp.data = params[:importer_exception_temp][:data]
    @temp.save
    respond_to do |f|
      f.js 
    end
  end

  def destroy
    @importer = Importer.find(params[:id])
    if params[:hide] 
      @importer.view_status = 0
      @importer.save
    else
      if @importer.destroy
        flash[:notice] = "已清除相关导入数据!!!"
      end
    end
    redirect_to params[:redirect_to] 
  end
end

#encoding: utf-8
module API 
  module Helpers
    def search_has_one_assoc_and_error!(model,assoc)
      if model.send(assoc)
        error!({ "error" => "已存在该公司的#{assoc}信息,若要修改请使用PUT"}, 400)
      end
    end
    
    def create_has_one_assoc_or_error!(model,assoc,attrs)
      @assoc = model.send("create_#{assoc}",attrs)
      if @assoc.new_record?
        error!({ "error" => "新建#{@assoc.class.model_name}失败", 
               "detail" => @assoc.errors.full_messages.join(",") }, 400)
      end
    end

    def update_has_one_assoc_or_error!(model,assoc,attrs)
      @assoc = model.send(assoc) 
      unless @assoc.update_attributes(attrs)
        error!({ "error" => "修改#{@assoc.class.model_name}失败", 
               "detail" => @assoc.errors.full_messages.join(",") }, 400)
      end
    end

    def create_or_update_has_one_assoc_or_error!(model,assoc,attrs)
      if model.send(assoc)
        update_has_one_assoc_or_error!(model,assoc,attrs)
      else
        create_has_one_assoc_or_error!(model,assoc,attrs)
      end
    end
    
    def search_company_or_error!
      company = Company.includes(:cert,:business,:credit).find_by_id(params[:id])
      unless company
        error!({ "error" => "找不到id为#{params[:id]}的公司"}, 400)
      end
      company
    end
  end
end

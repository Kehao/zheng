#encoding: utf-8
module CompaniesHelper

def contact_attrs
    [:reg_address, :reg_zip, :opt_address, :opt_zip, :zone, :industry, :tel, :fax, :email]
  end

  def changes1_attrs
    [:change_at, :name, :before_amount, :before_percent, :after_amount, :after_percent]
  end

  def changes2_attrs
    [:change_at, :event, :before, :after]
  end

  def owner_attrs
    [:category, :name, :sex, :birthday, :number, :education, :position, :address, :zip, :cv, :negative]
  end

  def new_or_edit_credit(company)
    if company.credit
      [:edit,company.credit]
    else
      new_credit_path(:company_id=>company.id) 
    end
  end

  def company_contents
    { 
      :base    => "1.基本信息",
      :contact => "2.联络信息",
      :changes => "3.股东变更",
      :owner   => "4.经营者",
      :opt     => "5.经营信息",
      :people  => "6.人员",
      :devise  => "7.设备",
      :place   => "8.场所",
      :bank    => "9.银行",
      :other   => "10.不良信息",
      :review  => "11.行业评价",
      :finance => "12.财务信息",
      :level   => "13.信用评价"
    }
  end
  ## ==============================
  ## For the view of badges class and relevant test in company index status
  def company_info_badges(client)
    company= client.company
    capture_haml do
      if can? :read, Cert #cert badge
        desc_string = Company.human_attribute_name("idinfo_status")
        link = link_to(desc_string, 
                         company_client_path(client), 
                         #:'data-toggle' => "tooltip", 
                         #:data => {placement: "top"}, 
                         :title => idinfo_status_title(company))
        haml_tag :span,link,
                 :class => "badge badge-#{badge_class_name(company.idinfo_status)}"
      end

      if can? :read, Crime #court badge
        desc_string = Company.human_attribute_name("court_status")
        haml_tag :span,
                 link_to(desc_string, company_client_path(client,:tab=>"company-other"), 
                           #rel: "tooltip", 
                           #data: {placement: "right"}, 
                           title: court_status_title(company)),
                 class: "badge badge-#{badge_class_name(company.court_status_with_owner)}"
      end
      if can? :read, Cert #cert badge
        desc_string = '经营'
        haml_tag :span,
                 link_to(desc_string, 
                         company_client_path(client,:tab=>"company-opt"), 
                          title: idinfo_status_title(company)),
                 # rel: "tooltip", 
                 # data: {placement: "right"}, 
                 class: "badge badge-#{badge_class_name(company.idinfo_status)}"

      end
      if can? :read, Crime #court badge
        desc_string = "信用"
        haml_tag :span,
                 link_to(desc_string, 
                         company_client_path(client,:tab=>"company-level"), 
                          #rel: "tooltip", 
                          #data: {placement: "right"}, 
                          title: (company.business.present? ? company.business.credit_avg_txt : "n/a")),
                 class: "badge badge-#{badge_class_name(company.business.try(:credit_avg_txt))}"
      end
    end
  end

  def badge_class_name(item)
    list = {
      "ok" => "success", 
      "closed" => "", 
      "stopped" => "", 
      "other" => "warning",
      "processing" => "important",
      
      "success" => "success",
      "info" => "info",
      "warning" => "warning",
      "important" => "important",

      "A++" => "success",
      "A+" => "success",
      "A" => "success",
      "B+" => "info",
      "B" => "warning",
      "B-" => "important",
      "C+" => "important",
      "C" => "important",
      "C-" => "important"
    }
      
    list[item]
  end

  ## ==============================
  ## For the view of icon-tag in company show info-title
  def idinfo_status_badge(company)
    capture_haml do 
      haml_tag :span, class: "badge badge-#{company.idinfo_status}" do
        haml_tag(:i, class: status_icon(company.idinfo_status))
      end
    end
  end
  
  def status_icon(status)
    case status
    when nil
      "icon-warning-sign"
    when "info"
      "icon-eye-open"
    when "warning"
      "icon-warning-sign"
    when "important"
      "icon-exclamation-sign"
    when "success"
      "icon-ok"
    end
  end

  def idinfo_status_title(company)
    if company.idinfo_status == "warning"
      "工商信息不完整"
    elsif company.idinfo_status == "important"
      "无法检索到工商信息"
    else
      ""
    end
  end

  def court_status_title(company)
    if company.court_status_with_owner != "ok"
      company.court_status_with_owner.text
    else
      "正常"
    end
  end
end

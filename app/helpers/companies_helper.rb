#encoding: utf-8
module CompaniesHelper
  ## ==============================
  ## For the view of badges class and relevant test in company index status
  def company_info_badges(company)
    capture_haml do
      if can? :read, Cert #cert badge
        desc_string = Company.human_attribute_name("idinfo_status")
        haml_tag :span,
                 link_to(desc_string, "javascript:;", class: "badge-link", rel: "tooltip", data: {placement: "right"}, title: idinfo_status_title(company)),
                 class: "badge badge-#{badge_class_name(company.idinfo_status)}"
      end
      if can? :read, Crime #court badge
        desc_string = Company.human_attribute_name("court_status")
        haml_tag :span,
                 link_to(desc_string, "javascript:;", class: "badge-link", rel: "tooltip", data: {placement: "right"}, title: court_status_title(company)),
                 class: "badge badge-#{badge_class_name(company.court_status_with_owner)}"
      end
      if can? :read, Cert #cert badge
        desc_string = '经营'
        haml_tag :span,
                 link_to(desc_string, "javascript:;", class: "badge-link"),
                 #, rel: "tooltip", data: {placement: "right"}, title: idinfo_status_title(company)
                 class: "badge badge-#{badge_class_name(company.idinfo_status)}"

      end
      if can? :read, Crime #court badge
        desc_string = "信用"
        haml_tag :span,
                 link_to(desc_string, "javascript:;", class: "badge-link", rel: "tooltip", data: {placement: "right"}, title: (company.business.present? ? company.business.credit_avg_txt : "n/a")),
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
      "工商信息不完整；"
    elsif company.idinfo_status == "important"
      "无法检索到工商信息；"
    else
      ""
    end
  end

  def court_status_title(company)
    if company.court_status_with_owner != "ok"
      company.court_status_with_owner.text
    else
      ""
    end
  end
end

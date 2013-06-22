#encoding: utf-8
module CompanyClientsHelper
  def relationship_select_options
    ClientCompanyRelationship.enumerized_attributes[:relate_type].options.map do |option|
      {"value" => option[1],"text"=>option[0]}
    end
  end

  def industry_select_options
    Industry.where(:id=>[100..119]).all.map do |industry|
      {"value" => industry.id,"text"=> industry.name}
    end
  end

  def editable_link(model,attr,data_url,data_type="text",data_value=nil)
    model_name = model.class.name.downcase
    attr_name = model.class.human_attribute_name(attr) 
    view_css_class = "#{model_name}_#{attr}"

    link_to (model && model.public_send(attr) || ""),"#",
      :class=>"#{model_name}_editable #{view_css_class} editable editable-click editable-empty",
      :'data-type'=> data_type,
      :'data-url'=> data_url,
      :'data-original-title'=>"修改#{attr_name}",
      :'data-resource'=> model_name,
      :'data-name'=> attr,
      :'data-value' => data_value 
  end

  def text_editable_link(model,attr,data_url)
    editable_link(model,attr,data_url)
  end

  def warning_context(company)
    context = ""
    
    if can? :read, Cert
      if company.idinfo_status == "warning"
        context += "工商信息不完整；"
      elsif company.idinfo_status == "important"
        context += "无法检索到工商信息；"
      end
    end

    if can? :read, Crime
      if company.court_status_with_owner != "ok"
        context += "法务: #{company.court_status_with_owner.text};"
      end
    end

    if context.blank?
      context = "无"
    end

    context
  end

  def court_tab(company)
    all_crimes = company_crimes = person_crimes = criming = recent_crimes = []
    unless company.court_status_with_owner.eql?("ok") 
      all_crimes     = company.all_crimes 
      #company_crimes = all_crimes.select{|crime| crime.party_typ.eql?("Company")}
      #person_crimes  = all_crimes.select{|crime| crime.party_typ.eql?("Person")}
      criming        = all_crimes.select{|crime| crime.case_state.scan(/执行中/)}
      recent_crimes  = all_crimes.select{|crime| crime.regist_date >= Date.today.months_ago(6)}
    end
    alerts = {
      "ok"      => ["alert alert-success",["正常 - 未检索到任何法务信息"]],
      "closed"  => ["alert",["正常 - 未检索到[执行中]法务信息","检测到 #{all_crimes.size} 条[已结]法务信息"]],
      "stopped" => ["alert",["正常 - 未检索到[执行中]法务信息","检测到 #{all_crimes.size} 条[已结]，[终止执行]或其他法务信息"]],
      "other"   => ["alert alert-warning",["异常 - 法务异常","检测到 #{all_crimes.size} 条[已结]或[终止执行]法务信息"]],
      "processing" => ["alert alert-error", [
        "警告 - 发现[执行中]法务信息",
        "#{criming.size} 条正在执行中",
        "#{recent_crimes.size} 条立案时间在近半年内"]
      ]}[company.court_status_with_owner]

      alerts_tag(alerts)
  end

  def cert_tab(company)
    alerts = {
      "success"   => ["alert alert-success",["正常 - 工商信息完整"]],
      "warning"   => ["alert alert-warning",["异常 - 工商信息不完整"]],
      "important" => ["alert alert-error",["警告 - 无法检索到工商信息"]]
    }[company.idinfo_status]
    alerts_tag(alerts)
  end

  def business_tab(company)
    status = 
    if company.business.nil?
       "important"
    elsif company.business.attributes.values.compact.size < 16
       "warning"
    else
       "success" 
    end
    alerts = {
      "success"   => ["alert alert-success",["正常 - 经营信息较完整"]],
      "warning"   => ["alert alert-warning",["异常 - 经营信息较不完整"]],
      "important" => ["alert alert-error",["警告 - 无企业经营信息"]]
    }[status]
    alerts_tag(alerts)
  end

  def alerts_tag(alerts)
    unless alerts.blank? 
      haml_tag(:div, class: alerts[0] ) do
        alerts[1].each{|msg| 
          haml_tag :p do haml_concat msg end
        }
      end
    end
  end

  def crimes_count_tip(crimes)
    if crimes.detect{|crime| crime.case_state =~ /执行中/}
    "(#{crimes.size}<span class='red'>*</span>)"
    else
      "(#{crimes.size})"
    end
  end

  def relationship_tab(company)
    status = "ok"
    crime_relationship_count = criming_relationship_count = recent_crime_relationship_count = 0
    @relationships.each do |relationship|
      crimes = 
        if relationship.is_a?(ClientCompanyRelationship) 
          relationship.company.crimes
        else
          if relationship.person 
            relationship.person.crimes
          else
            []
          end
        end
      criming = crimes.detect{|crime| crime.case_state =~ /执行中/}
      recent_crimed = crimes.detect{|crime| crime.regist_date >= Date.today.months_ago(6)}
      unless crimes.blank?
        crime_relationship_count += 1
      end
      if criming
        criming_relationship_count += 1
      end
      if recent_crimed 
        recent_crime_relationship_count += 1
      end
    end
    alert_text = []
    unless @relationships.size.zero?
      alert_text << "共有#{@relationships.size} 个关联" 
    end
    unless crime_relationship_count.zero?
      status = "warning"
      alert_text << "#{crime_relationship_count} 个关联对象有案件信息" 
    end
    unless criming_relationship_count.zero?
      status = "error"
      alert_text << "#{criming_relationship_count} 个关联对象有[执行中]案件信息" 
    end
    unless recent_crime_relationship_count.zero?
      status = "error"
      alert_text << "#{recent_crime_relationship_count} 个关联对象立案时间在近半年内"  
    end
    alerts = {
      "ok"      => ["alert alert-success",(["正常 - 关联对象没有案件信息"] + alert_text)],
      "warning" => ["alert alert-warning",(["异常 - 关联对象有案件信息"] + alert_text)],
      "error"   => ["alert alert-error",(["警告 - 关联对象有[执行中]案件信息"]  + alert_text)]
    }[status]

    alerts_tag(alerts)
  end

  def warning_msg_sb(company)
    capture_haml do
      if can? :read, Cert
        case company.idinfo_status
        when "success"
          haml_tag(:div, class: "alert alert-success") do
            haml_tag :h4, "工商信息："
            haml_concat "正常;"
          end
        when "warning"
          haml_tag(:div, class: "alert alert-warning") do
            haml_tag :h4, "工商信息："
            haml_concat "发现异常 - 工商信息不完整;"
          end
        when "important"
          haml_tag(:div, class: "alert alert-error") do
            haml_tag :h4, "工商信息："
            haml_concat "发现警告 - 无法检索到工商信息;"
          end
        end
      end

      if can? :read, Crime
        case company.court_status_with_owner
        when "ok"
          haml_tag(:div, class: "alert alert-success") do
            haml_tag :h4, "法务信息："
            haml_concat "正常 - 未检索到任何法务信息;"
          end
        when "closed"
          haml_tag(:div, class: "alert alert") do
            haml_tag :h4, "法务信息："
            haml_concat "正常 - 未检索到[执行中]法务信息;"
            crimes_count = company.all_crimes.count
            haml_concat "<br/>检测到 #{crimes_count} 条[已结]法务信息;"
          end
        when "stopped"
          haml_tag(:div, class: "alert") do
            haml_tag :h4, "法务信息："
            haml_concat "正常 - 未检索到[执行中]法务信息;"
            crimes_count = company.all_crimes.count
            haml_concat "<br/>检测到 #{crimes_count} 条[已结]，[终止执行]或其他法务信息;"
          end
        when "other"
          haml_tag(:div, class: "alert alert-warning") do
            haml_tag :h4, "法务信息："
            haml_concat "发现异常 - 法务异常;"
            crimes_count = company.all_crimes.count
            haml_concat "<br/>检测到 #{crimes_count} 条[已结]或[终止执行]法务信息;"
          end
        when "processing"
          haml_tag(:div, class: "alert alert-error") do
            haml_tag :h4, "法务信息："
            crimes_count = company.all_crimes.count
            haml_concat "发现警告 - 检测到 #{crimes_count} 条法务信息;"

            company_crimes_count = company.crimes.count
            person_crimes_count = crimes_count - company_crimes_count
            haml_concat "<br/>其中 #{company_crimes_count} 条公司法务 & #{person_crimes_count} 条个人法务;"
            ing_count = company.all_crimes.find_all{|cc| !cc.case_state.scan(/执行中/).blank?}.count
            haml_concat "<br/>#{ing_count} 条法务信息正在执行中;"
            recent_count = company.all_crimes.find_all{|cc| cc.regist_date >= Date.today.months_ago(6)}.count
            haml_concat "<br/>#{recent_count} 条立案时间在近半年内;"
          end
        end
      end

      cc = company.company_clients.find_by_user_id(current_user)
      related_c_crimes = cc.company_relationships.map(&:company).compact.map(&:crimes).flatten
      related_p_crimes = cc.person_relationships.map(&:person).compact.map(&:crimes).flatten
      related_crimes = related_c_crimes + related_p_crimes
      crimes_count = related_crimes.count
      if crimes_count > 0
        haml_tag(:div, class: "alert alert-warning") do
          haml_tag :h4, "关联方法务："
          haml_concat "发现警告 - 检测到 #{crimes_count} 条法务信息;"

          company_crimes_count = related_c_crimes.count
          person_crimes_count = crimes_count - company_crimes_count
          haml_concat "<br/>其中 #{company_crimes_count} 条公司法务 & #{person_crimes_count} 条个人法务;"
          ing_count = related_crimes.flatten.find_all{|cc| !cc.case_state.scan(/执行中/).blank?}.count
          haml_concat "<br/>#{ing_count} 条法务信息正在执行中;"
          recent_count = related_crimes.flatten.find_all{|cc| cc.regist_date >= Date.today.months_ago(6)}.count
          haml_concat "<br/>#{recent_count} 条立案时间在近半年内;"
        end
      else
        haml_tag(:div, class: "alert alert-success") do
          haml_tag :h4, "关联方法务："
          haml_concat "正常 - 未检索到任何法务信息;"
        end
      end
    end
  end

  def relationship_target_type(relationship)
    relationship.is_a?(ClientCompanyRelationship) ? "company" : "person"
  end
end

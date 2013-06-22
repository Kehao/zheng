# encoding: utf-8
module ApplicationHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?
      
      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end


  def seconds_to_offset(offset_seconds)
      format = '%02d小时%02d分%02d秒'
      hours = offset_seconds / 3600
      minutes = (offset_seconds % 3600) / 60
      seconds = offset_seconds % 60
      format % [hours, minutes,seconds]
  end

############navs for skyeye############
  def active?(tab)
    tab.to_s == controller_name ? true : false 
  end

  def tab_class(tab,*extra_class)
     if active?(tab)
       extra_class.push "active"
     end
     extra_class.join(" ")
  end

  def edit_user_nav
      content_tag :ul,:class=>"nav nav-tabs" do
        concat (content_tag :li,(link_to "基本信息设置",edit_user_registration_path),:class => tab_class(:registrations))
        concat (content_tag :li,(link_to "告警设置",edit_user_alarm_config_path),:class => tab_class(:alarm_configs))
      end
  end
  
  def base_url
    if request
      "#{request.protocol}#{request.ip}#{request.port_string}"
    else
      ""
    end
  end

 

  def court_snapshot_link(crime)
    if crime && crime.snapshot_path.present?
      unless block_given?
        link_to "有", snapshot_url(crime), :target=>"_blank"  
      else
        link_to snapshot_url(crime), :target=>"_blank" do 
          yield
        end
      end
    else
      unless block_given?
        "无"
      else
        yield
      end
    end
  end

  def idinfo_snapshot_link(cert)
    if cert && cert.snapshot_path.present?
      link_to "工商截图",snapshot_url(cert), :target=>"_blank"  
    end
  end
  
  def snapshot_url(obj)
    obj.snapshot_path =~ /public(.*)$/
    $1
  end

  def mapto_activities(owner)
     main_app.activities_path(:owner_id=>owner.id,:owner_type=>owner.class.name)
  end


  def ability_checked(role,source_name,action) 
    #able=role.has_ability_item?(source_name,action)
    #return !!Role.default_permissions[source_name][action] unless able
    role.has_ability?(source_name,action)
  end

  def selected(cur, required, class_name = "active")
    if required == :blank
      cur.blank? ? class_name : nil 
    else
      cur == required ? class_name : nil 
    end 
  end

  # 在页面中需要渲染 各个插件相应的cell页面
  def render_plugin_cell(name, *args, &block)
    Skyeye.plugins.map do |plugin|
      render_cell_exist plugin.cell, name, *args, &block
    end.join.html_safe
  end
  alias_method :render_plugins_cell, :render_plugin_cell

  def render_user_plugin_cell(user, name, *args, &block)
    user.plugins.map { |plugin|
      render_cell_exist plugin.cell, name, *args, &block
    }.join.html_safe
  end

  # 渲染存在的cell state, 如果不存在返回nil
  def render_cell_exist(name, state, *args, &block )
    if "#{name}_cell".camelize.constantize.method_defined?(state)
      render_cell(name, state, *args, &block)
    end
  rescue NameError
    nil
  end
end

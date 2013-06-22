module MessagesHelper
  def render_message(msg)
    send "render_#{msg.event_type.underscore}", msg.event, msg
  end

  def render_notice(notice, msg)
    name = notice.class.name.underscore
    render name, name.to_sym => notice, :msg => msg
  end
end

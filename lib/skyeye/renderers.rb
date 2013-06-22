#ActionController::Renderers.add :csv do |obj, options|
#  filename = options[:filename] || 'data'
#  str = obj.respond_to?(:to_csv) ? obj.to_csv : obj.to_s
#  send_data str, :type => :csv,
#    :disposition => "attachment; filename=#{filename}.csv"
#end
#
#ActionController::Renderers.add :xls do |obj, options|
#  filename = options[:filename] || 'data'
#  str = obj.respond_to?(:to_xls) ? obj.to_xls : obj.to_s
#  send_data str, :type => :xls,
#    :disposition => "attachment; filename=#{filename}.xls"
#end
#
ActionController::Renderers.add :pdf do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.respond_to?(:to_xls) ? obj.to_xls : obj.to_s
  send_data str, :type => "application/pdf", :disposition => "attachment; filename=#{filename}.xls"
end

#f.pdf {
    #  render :pdf=>"statistics_global_#{Time.now.strftime("%Y%m%d")}.pdf",
    #  :template =>"statistics/index.pdf.haml",  
    #  :layout=> 'pdf.html.haml',       
    #  :show_as_html => params[:debug].present?,
    #  :page_size   => "A3",
    #  :page_offset => 0
    #}
#f.pdf {
#        @company_clients = current_user.court_problem_company_clients.includes(:company => [:cert, :owner]).limit(100)
#        render :pdf=>"court_problem#{Time.now.strftime("%Y%m%d")}.pdf",:template =>"company_clients/court_problem.pdf.haml",  
#          :layout=> 'pdf.html.haml',
#          :show_as_html => params[:debug].present?,
#          :page_size   => "A4",
#          :zoom => 0.5
#      }

#encoding: utf-8
module SeeksHelper
  def seek_content_of(seek)
    capture_haml do
      case seek.content.first[0] #the searching key
      when :company_name
        haml_tag :i, class: 'icon-home'
      when :company_number
        haml_tag :i, class: 'icon-barcode'
      when :person_name
        haml_tag :i, class: 'icon-user'
      when :person_number
        haml_tag :i, class: 'icon-th-list'
      end
      haml_concat seek.content.first[1] #the searching word
    end
  end
end

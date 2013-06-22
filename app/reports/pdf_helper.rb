#encoding: utf-8
module PdfHelper
  # This is the default value for the margin box
  #
  BOX_MARGIN   = 36

  # Additional indentation to keep the line measure with a reasonable size
  # 
  INNER_MARGIN = 30

  # Vertical Rhythm settings
  #
  RHYTHM  = 10
  LEADING = 2

  # Colors
  #
  BLACK      = "000000"
  LIGHT_GRAY = "F2F2F2"
  GRAY       = "DDDDDD"
  DARK_GRAY  = "333333"
  BROWN      = "A4441C"
  ORANGE     = "F28157"
  LIGHT_GOLD = "FBFBBE"
  DARK_GOLD  = "EBE389"
  BLUE       = "0000D0"
  LIGHT_BLUE = "ADD8E6"
  DEEP_BLUE  = "336699"

  def pdf_init
    init_font
    #45 10
    define_grid(:columns => 10, :rows => 20, :gutter => 10)
  end

  def init_font
    register_fonts
    font "Hwkt"
    font_size 13
  end

  def person(operator)
    p2_title("1. #{operator.category && operator.category.text || ""}")
    pdf_table([
              ["姓 名",operator.name,"性 别",operator.sex.text,"出生日期",operator.birthday],
              ["身份证号",operator.number,"最后学历",operator.education,"现任职务",operator.position]
    ],:width=>430)

    pdf_table([
              ["目前住址",operator.address,"邮政编码",operator.zip]
      ],:width=>430)

    pdf_table([
              ["工作经历",operator.cv],
              ["负面信息",operator.negative]
    ],:width=>430)
  end

  def content_cert(company)
    grid([3,1],[14,8]).bounding_box do
      p_title("（一）基本信息")
      pdf_table([ 
        ["公司名称",company.name],
        [Cert.human_attribute_name(:regist_id),company.number || company.cert.try(:regist_id)],
        [Cert.human_attribute_name(:owner_name),company.owner_name],
        [Cert.human_attribute_name(:address),company.address],
        [Cert.human_attribute_name(:business_scope),company.business_scope],
        [Cert.human_attribute_name(:company_type),company.company_type],
        [Cert.human_attribute_name(:found_date),company.found_date],
        [Cert.human_attribute_name(:approved_date),company.approved_date],
        [Cert.human_attribute_name(:business_period),company.business_period],
        [Cert.human_attribute_name(:paid_in_capital),company.paid_in_capital],
        [Cert.human_attribute_name(:regist_capital),company.regist_capital],
        [Cert.human_attribute_name(:regist_org),company.regist_org],
        [Cert.human_attribute_name(:check_years),(company.check_years.present? && company.check_years || "无法检索到工商年检信息")]
      ],:column_widths => {0 => 80},:width=>430)
    end

  end

  def pdf_top(str)
    repeat(:all) do
      formatted_text([{:text =>str,:size=>12}],:align => :right)
      stroke_horizontal_rule
      #grid.show_all
    end
  end

  def pdf_end
        formatted_text([{:text =>"———— 报告结束————",:size=>13}],:align => :center)
        move_down 8
        formatted_text([{:text =>"北京冠捷时速信息咨询有限责任公司",:size=>15}],:align => :center)
        move_down 8
        formatted_text([{:text =>"010-68575707",:size=>13}],:align => :center)
  end

  def pdf_title(company_name)
    grid([5,2], [10,7]).bounding_box do
        data = [ 
          ["<font size='15'><color rgb='#{DEEP_BLUE}'> 融资平台征信生产系统</color></font>"],
          ["<font size='45'><color rgb='#{DEEP_BLUE}'> 信用分析报告</color></font>"],
          ["<font size='15'><color rgb='#{DEEP_BLUE}'> 企业名称：#{company_name}</color></font>"]
        ]
        table(data,:cell_style=>{
          :border_width => [0,0,0,3],
          :border_color => DEEP_BLUE,
          :inline_format => true
        })
    end
  end

  def p2_title(title)
    font_size(13) do
      move_down 15
      formatted_text([{:text =>title}],:align => :left)
      move_down 5
    end
  end

  def p_title(title)
    font_size(20) do
      move_down 5
      formatted_text([{:text =>title,:color=>DEEP_BLUE}],:align => :left)
      move_down 5
    end
  end

  def pdf_company
    grid([17,2], [18,7]).bounding_box do
      formatted_text([{:text =>"北京冠捷时速信息咨询有限责任公司",:color=>DEEP_BLUE}],:align => :left)
      move_down 8
      formatted_text([{:text =>"#{Time.now.strftime("%Y-%m-%d")}",:color=>DEEP_BLUE}],:align => :left)
    end
    #stroke_bounds 
  end

  def content_title(title)
    formatted_text([{:text =>title,:size=>18}],:align =>:center)
    move_down 5 
    stroke_color DEEP_BLUE
    stroke_horizontal_rule 
    move_down 8
  end


  def pdf_need_know
    start_new_page
    grid([1,1], [19,8]).bounding_box do
      font_size(16) do
        content_title("报告阅读须知")
        space2 = Prawn::Text::NBSP * 2
        space5 = Prawn::Text::NBSP * 5
        font_size(12) do
          texts = []
          texts << "1.#{space2}本报告的著作权属于北京冠捷时速信息咨询有限责任公司，未经书面许可，不"
          texts << "#{space5}得擅自复制、摘录、编辑、转载、披露和发表。"

          texts << "2.#{space2}本报告仅供查询机构参考，不起任何证明作用且。本报告仅限查询依照法律法"
          texts << "#{space5}规规章所规定的查询用途使用，不得擅自向任何非查询人或机构泄露和发布本"
          texts << "#{space5}报告的所涉及的任何信息。" 

          texts << "3.#{space2}本报告的生成依据是截至报告时间为止的企业征信数据库中的相关信息。"

          texts << "4.#{space2}征信机构承诺保持其客观、中立的地位，并保证将这一原则贯穿于信息汇总、"
          texts << "#{space5}加工、整合的全过程中。"

          texts << "5.#{space2}请妥善保管本报告，并注意保密。"
          texts.each do |t|
            formatted_text([{:text =>t,:leading => 5}],:align => :left)
            move_down 15 
          end
        end
      end
    end
  end

  def pdf_table(data,options={})
    #:row_colors=>["F0F0F0",LIGHT_BLUE]
    table(data,{:cell_style=>{:inline_format=>true}}.merge(options))
  end

  def example_header(package, example)
    header_box do
      register_fonts
      font('Hwxk', :size => 18) do
        formatted_text([ { :text => package, :color => BROWN  },
                       { :text => "/",     :color => BROWN  },
                       { :text => example, :color => ORANGE }
        ], :valign => :center)
      end
    end
  end

  # Register fonts used on the manual
  #
  def register_fonts
    #kai_file = "#{Prawn::DATADIR}/fonts/gkai00mp.ttf"
    hwxk_file = "#{Prawn::DATADIR}/fonts/Hwxk.ttf"
    font_families["Hwxk"] = {
      :normal => { :file => hwxk_file, :font => "Hwxk" }
    }

    hwkt_file = "#{Prawn::DATADIR}/fonts/Hwkt.ttf"
    font_families["Hwkt"] = {
      :normal => { :file => hwkt_file, :font => "Hwkt" }
    }
  end

  # Render a block of text after processing code tags and URLs to be used with
  # the inline_format option.
  #
  # Used on the introducory text for example pages of the manual and on
  # package pages intro
  #
  def prose(str)

    # Process the <code> tags
    str.gsub!(/<code>([^<]+?)<\/code>/,
              "<font name='Courier'><b>\\1<\/b><\/font>")

    # Process the links
    str.gsub!(/(https?:\/\/\S+)/,
              "<color rgb='#{BLUE}'><link href=\"\\1\">\\1</link></color>")

    inner_box do
      font("Helvetica", :size => 11) do
        str.split(/\n\n+/).each do |paragraph|

          text(paragraph.gsub(/\s+/," "),
               :align         => :justify,
               :inline_format => true,
               :leading       => LEADING,
               :color         => DARK_GRAY)

          move_down(RHYTHM)
        end
      end
    end

    move_down(RHYTHM)
  end

  # Render a code block. Used on the example pages of the manual
  #
  def code(str)
    pre_text = str.gsub(' ', Prawn::Text::NBSP)
    pre_text = ::CodeRay.scan(pre_text, :ruby).to_prawn

    font('Courier', :size => 9.5) do
      colored_box(pre_text, :fill_color => DARK_GRAY)
    end
  end

  # Renders a dashed line and evaluates the code inline
  #
  def eval_code(source)
    move_down(RHYTHM)

    dash(3)
    stroke_color(BROWN)
    stroke_horizontal_line(-BOX_MARGIN, bounds.width + BOX_MARGIN)
    stroke_color(BLACK)
    undash

    move_down(RHYTHM*3)
    begin
      eval(source)
    rescue => e
      puts "Error evaluating example: #{e.message}"
      puts
      puts "---- Source: ----"
      puts source
    end
  end

  # Renders a box with the link for the example file
  #
  def source_link(example)
    url = "#{MANUAL_URL}/#{example.parent_folder_name}/#{example.filename}"

    reason = [{ :text  => "This code snippet was not evaluated inline. " +
      "You may see its output by running the " +
      "example file located here:\n",
      :color => DARK_GRAY },

      { :text   => url,
        :color  => BLUE,
        :link   => url}
    ]

    font('Helvetica', :size => 9) do
      colored_box(reason,
                  :fill_color   => LIGHT_GOLD,
                  :stroke_color => DARK_GOLD,
                  :leading      => LEADING*3)
    end
  end

  # Render a page header. Used on the manual lone pages and package
  # introductory pages
  #
  def header(str)
    header_box do
      register_fonts
      font('Hwxk', :size => 24) do
        text(str, :color  => BROWN, :valign => :center)
      end
    end
  end

  # Render the arguments as a bulleted list. Used on the manual package
  # introductory pages
  #
  def list(*items)
    move_up(RHYTHM)

    inner_box do
      font("Hwkt", :size => 11) do
        items.each do |li|
          float { text("•") }
          indent(RHYTHM) do
            text(li.gsub(/\s+/," "), 
                 :inline_format => true,
                 :leading       => LEADING)
          end

          move_down(RHYTHM)
        end
      end
    end
  end

  # Renders the page-wide headers
  #
  def header_box(&block)
    bounding_box([-bounds.absolute_left, cursor + BOX_MARGIN],
                 :width  => bounds.absolute_left + bounds.absolute_right,
                 :height => BOX_MARGIN*2 + RHYTHM*2) do

      fill_color LIGHT_GRAY
      fill_rectangle([bounds.left, bounds.top],
                     bounds.right,
                     bounds.top - bounds.bottom)
      fill_color BLACK

      indent(BOX_MARGIN + INNER_MARGIN, &block)
    end

    stroke_color GRAY
    stroke_horizontal_line(-BOX_MARGIN, bounds.width + BOX_MARGIN, :at => cursor)
    stroke_color BLACK

    move_down(RHYTHM*3)
  end

  # Renders a Bounding Box for the inner margin
  #
  def inner_box(&block)
    bounding_box([INNER_MARGIN, cursor],
                 :width => bounds.width - INNER_MARGIN*2,
                 &block)
  end

  # Renders a Bounding Box with some background color and the formatted text
  # inside it
  #
  def colored_box(box_text, options={})
    options = { :fill_color   => DARK_GRAY,
      :stroke_color => nil,
      :text_color   => LIGHT_GRAY,
      :leading      => LEADING
    }.merge(options)

    register_fonts
    text_options = { :leading        => options[:leading], 
      :fallback_fonts => ["Hwxk","Hwkt"]
    }

    box_height = height_of_formatted(box_text, text_options)

    bounding_box([INNER_MARGIN + RHYTHM, cursor],
                 :width => bounds.width - (INNER_MARGIN+RHYTHM)*2) do

      fill_color   options[:fill_color]
      stroke_color options[:stroke_color] || options[:fill_color]
      fill_and_stroke_rounded_rectangle(
        [bounds.left - RHYTHM, cursor],
        bounds.left + bounds.right + RHYTHM*2,
        box_height + RHYTHM*2,
        5
      )
      fill_color   BLACK
      stroke_color BLACK

      pad(RHYTHM) do
        formatted_text(box_text, text_options)
      end
                 end

    move_down(RHYTHM*2)
  end

  # Draws X and Y axis rulers beginning at the margin box origin. Used on
  # examples.
  #
  def stroke_axis(options={})
    options = { :height => (cursor - 20).to_i,
      :width => bounds.width.to_i
    }.merge(options)

    dash(1, :space => 4)
    stroke_horizontal_line(-21, options[:width], :at => 0)
    stroke_vertical_line(-21, options[:height], :at => 0)
    undash

    fill_circle [0, 0], 1

    (100..options[:width]).step(100) do |point|
      fill_circle [point, 0], 1
      draw_text point, :at => [point-5, -10], :size => 7
    end

    (100..options[:height]).step(100) do |point|
      fill_circle [0, point], 1
      draw_text point, :at => [-17, point-2], :size => 7
    end
  end

  # Reset some of the Prawn settings including graphics and text to their
  # defaults.
  # 
  # Used after rendering examples so that each new example starts with a clean
  # slate.
  #
  def reset_settings

    # Text settings
    font("Helvetica", :size => 12)
    default_leading 0
    self.text_direction = :ltr

    # Graphics settings
    self.line_width = 1
    self.cap_style  = :butt
    self.join_style = :miter
    undash
    fill_color   BLACK
    stroke_color BLACK
  end

end

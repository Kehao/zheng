#encoding: utf-8
#Prawn.debug = true
class CompanyClientReport < Prawn::Document
  include PdfHelper
  include ContentHelper

  attr_accessor :company_client
  def to_pdf
    company = company_client.company
    credit = company.credit

    pdf_init
    pdf_top("北京冠捷时速·信用分析报告")
    #page 1
    pdf_title(company.name)
    pdf_company

    #page 2
    pdf_need_know
    #page 3
    start_new_page
    grid([1,1],[2,8]).bounding_box do
      content_title("信用分析报告")
      float do
        formatted_text([{:text =>"本报告仅向报告提供对象提供",:size=>12}],:align => :left)
      end
      formatted_text([{:text =>"打印日期：#{Time.now.strftime("%Y-%m-%d")}",:size=>12}],:align => :right)
    end

    content_cert(company)

    #page 4
    start_new_page
    bounding_box([55,cursor - 20],:width=>430) do
      p_title("（二）联络信息")
      pdf_table([ 
                ["注册地址：#{credit.reg_address}","邮政编码：#{credit.reg_zip}"],
                ["经营地址：#{credit.opt_address}","邮政编码：#{credit.opt_zip}"]
      ],:column_widths => {0 => 300},:width=>430)
      pdf_table([ 
                ["所在园区：#{credit.zone}"],
                ["所属行业：#{credit.industry}"],
                ["联系电话：#{credit.tel}"],
                ["联系传真：#{credit.fax}"],
                ["电子邮箱：#{credit.email}"],
                ["网 址：#{credit.website}"]
      ],:width=>430)
      move_down 20 


      p_title("（三）股东构成及关联公司")
      p2_title("1. 股东构成")
      shareholders = company_client.relationships.select{|rela|rela.relate_type.eql?("shareholder")}
      data = [["股东名称","注册地址","法定代表人","出资比例(%)","出资额(万元)","出资形式"]]
      shareholders.each do |shareholder|
        if shareholder.is_a?(ClientCompanyRelationship)
           company = shareholder.company
           data << [company.name,company.area_desc,company.owner_name,(shareholder.hold_percent * 100),"",""]
        else
           person = shareholder.person
           data << [shareholder.person_name,"","",(shareholder.hold_percent * 100),"",""]
        end
      end
      pdf_table(data,:width=>430)
      
      sub_companys = company_client.relationships.select{|rela|rela.relate_type.eql?("sub_company")}
      if sub_companys.present?
        p2_title("2. 关联企业") 
        data = []
        sub_companys.each do |sub_company|
          data << ["子公司",sub_company.company.name]
        end
        pdf_table(data,:column_widths => {0 => 80},:width=>430)
      end

      float do
        p2_title("3. 股东及股权变更情况")
      end
      move_down 15
      formatted_text([{:text =>"单位：万元",:size=>12}],:align => :right)
      move_down 5

      holder_changes = credit.holder_changes 
      data = [["变更日期", "股东名称", "变更前出资比例(%)","变更前出资额(万元)", "变更后出资比例(%)","变更后出资额(万元)"]]
      holder_changes.each do |holder_change|
        data <<  [holder_change.change_at, holder_change.name, holder_change.before_percent,holder_change.before_amount, holder_change.after_percent,holder_change.after_amount]
      end
      pdf_table(data,:width=>430)


      mass_changes = credit.mass_changes 
      data = [["变更事项", "变更日期","变更前","变更后"]]
      mass_changes.each do |mass_change|
        data << [mass_change.event,mass_change.change_at,mass_change.before,mass_change.after]
      end
      p2_title("4.其他重大变更(含公司名称、注册地址、注册资金、法定代表人、经营范围、企业类别)")
      pdf_table(data,:width=>430)


      move_down 20
      p_title("(四)主要经营者背景(含法定代表人、总经理、技术负责 人和财务负责人等)")
      credit.operators.each do |operator|
        person(operator)
      end

      move_down 20
      p_title("(五)经营信息")
      pdf_table([
                ["主营产品或服务",credit.main_product],
                ["销售区域",credit.sales_region],
                ["客户类型",credit.clients_type],
                ["列举主要上游供应商/合作方及付款方式",credit.upstream],
                ["列举主要下游客户及收款方式",credit.downstream],
                ["运营阶段",credit.opt_stage]
      ],:column_widths => {0 => 150},:width=>430)


      move_down 20
      p_title("(六)人员状况")
      pdf_table([
                ["人员总数: #{credit.epl_count}人"],
                ["人员学历构成:硕士以上 #{credit.master} 人,大学本科 #{credit.bachelor} 人,大专 #{credit.junior} 人,其他学历 #{credit.other} 人"]
      ],:width=>430)


      move_down 20
      p_title("(七)生产/ 研发/ 经营等主要设备")
      equips = credit.equips
      data = [["设备名称","数量","技术水平","备注"]]
      equips.each do |equip|
        data << [equip.name,equip.count,equip.tech,equip.memo]
      end
      pdf_table(data,:width=>430)

      move_down 20
      p_title("(八)经营场所")

      pdf_table([
                ["房产性质","自有","租赁","按揭"],
                ["房产总面积(平方米)",credit.self_area, credit.rent_area, credit.mort_area],
                ["其中:总部面积",credit.self_head, credit.rent_head, credit.mort_head],
                ["分部面积",credit.self_branch, credit.rent_branch, credit.mort_branch],
                ["房产原值或年租金(万元)",credit.self_value, credit.rent_value, credit.mort_value]
      ],:width=>430)

      move_down 20
      p_title("(九)银行信息")
      p2_title("1.开户信息")
      pdf_table([
                ["开户行: #{credit.bank_name}"],
                ["帐号: #{credit.bank_account}"],
                ["开户行地址: #{credit.bank_address}"],
                ["开户行电话: #{credit.bank_tel}"],
                ["月均存款位数:  #{credit.avg_digits}位"],
                ["信用等级: #{credit.bank_level}"]
      ],:width=>430)


      float do
        p2_title("2.贷款情况")
      end
      move_down 15
      formatted_text([{:text =>"单位：万元",:size=>12}],:align => :right)
      move_down 5

      loans = credit.loans
      data = [["贷款行名称","贷款种类","贷款额度","贷款期限","到期日","目前余额"]]
      loans.each do |loan|
        data << [loan.name,loan.category,loan.amount,loan.due_time,loan.deadline,loan.balance]
      end
      pdf_table(data,:width=>430)

      float do
        p2_title("3.对外担保情况")
      end
      move_down 15
      formatted_text([{:text =>"单位：万元",:size=>12}],:align => :right)
      move_down 5

      morts = credit.morts
      data = [["被担保人名称","担保种类","担保额度","担保期限","到期日","目前余额"]]
      morts.each do |mort|
        data << [mort.name,mort.category,mort.amount,mort.due_time,mort.deadline,mort.balance]
      end
      pdf_table(data,:width=>430)

      move_down 20
      p_title("(十)其它信息(包括贷款、担保、交易、工商注册、企业经营、税务、司法、社保、行业管理及其他方面的不良记录)")
      crimes = company.all_crimes.sort_by(&:regist_date).reverse

      data = []
      [[credit.bad_cert,"1. 不良工商记录:","有( ) 无( √ )","有( √ ) 无( )"],
      [credit.bad_tax,"2. 不良税务记录:","有( ) 无( √ )","有( √ ) 无( )"],
      [credit.bad_social,"3. 不良社保记录:","有( ) 无( √ )","有( √ ) 无( )"],
      [credit.bad_trade,"4. 不良交易记录:","有( ) 无( √ )","有( √ ) 无( )"],
      [credit.involved_before,"5. 是否曾参与、申请征信或评级:","是( ) 否( √ )","是( √ ) 否( )"],
      [credit.bad_manage,"6. 行业管理的不良记录:","有( ) 无( √ )","有( √ ) 无( )"],
      [(company.court_crawled && crimes.present?),"7. 不良司法记录:","有( ) 无( √ )","有( √ ) 无( )"]].each do | da |

      tmp = da[0] && da[3] || da[2]
      data << [da[1],tmp]
      end
      table(data,:cell_style=>{:inline_format=>true,:border_width => 0},:column_widths => {0 =>300},:width=>430)

      move_down 5
      data =  []
      if company.court_crawled 
        if crimes.present?
          data << [
            Crime.human_attribute_name(:reg_date),
            "状态",
            "当事人",
            Crime.human_attribute_name(:party_number),
            Crime.human_attribute_name(:case_id), 
            Crime.human_attribute_name(:apply_money)]
            crimes.each do |crime|
              data << [
                crime.reg_date,
                crime.case_state,
                crime.party_name, 
                crime.party_number,
                crime.case_id,
                crime.apply_money
              ]
            end
        else
          data << ["该企业尚未检测到相关法务记录"]
        end
      else
        data << ["该企业的法务信息尚未检索完成"]
      end
      pdf_table(data)

      move_down 20
      p_title("(十一) 行业评价")
      industry_review = (credit.industry_review.present? && credit.industry_review || "暂无评价")
      pdf_table([[industry_review]],:width=>430)

      move_down 20
      p_title("(十二) 财务信息")
          data = [[
          "<font size='15'>年份</font>",
          "<font size='15'>今年截止至上个月</font>",
          "<font size='15'>去年(万元)</font>",
          "<font size='15'>前年(万元)</font>"]]


          ["income","assets","debt","profit"].each do |item|
            data << [
              Business.human_attribute_name(item),
              (company.business && company.business.public_send("#{item}_of_this_year") || ""),
              (company.business && company.business.public_send("#{item}_of_last_year") || ""),
              (company.business && company.business.public_send("#{item}_of_the_year_before_last") || ""),
            ]
            end

          ["gross_profit",
           "ratio_return",
           "ratio_net_return",
           "ratio_asset_liability",
           "ratio_liquidity",
           "ratio_quick",
           "ratio_ar",
           "ratio_inventory",
           "ratio_assets"
          ].each do |item|

            data << [
              Credit.human_attribute_name("#{item}_0"),
              (credit && credit.public_send("#{item}_2") || ""),
              (credit && credit.public_send("#{item}_1") || ""),
              (credit && credit.public_send("#{item}_0") || "")
            ]
          end
          pdf_table(data)

      move_down 20
      p_title("(十三) 信用评价")

      if company.business
        
          scale_score=company.business.scale_score.to_i != 50 ? company.business.scale_score : "未知"
          scale_score_txt=company.business.scale_score.to_i != 50 ? company.business.txt_of(:scale_score) : "n/a"

          sales_score=company.business.sales_score.to_i != 50 ? company.business.sales_score : "未知"
          sales_score_txt=company.business.sales_score.to_i != 50 ? company.business.txt_of(:sales_score) : "n/a"

          profit_score=company.business.profit_score.to_i != 50 ? company.business.profit_score : "未知"
          profit_score_txt=company.business.profit_score.to_i != 50 ? company.business.txt_of(:profit_score) : "n/a"

          credit_score=company.business.credit_score.to_i != 50 ? company.business.credit_score : "未知"
          credit_score_txt=company.business.credit_score.to_i != 50 ? company.business.txt_of(:credit_score) : "n/a"

          credit_avg=company.business.credit_avg.to_i != 50 ? company.business.credit_avg : "未知"
          credit_avg_txt=company.business.credit_avg.to_i != 50 ? company.business.txt_of(:credit_avg) : "n/a"



        table([ 
                  ["<font size='15'>主要指标</font>",
                    "<font size='15'>评分</font>",
                    "<font size='15'>评价</font>"],
                  ["企业规模:",scale_score,scale_score_txt],
                  ["财务状况:",sales_score,sales_score_txt],
                  ["发展空间:",profit_score,profit_score_txt],
                  ["公信力数据:",credit_score,credit_score_txt],
                  ["信用等级:", credit_avg, credit_avg_txt],
        ],:cell_style=>{:inline_format=>true,:border_color => "A7DFF1"}
)
      else
        formatted_text([{:text =>"暂无信用评价"}],:align => :left)
      end
       move_down 10
       formatted_text([{:text =>"说明:信用等级将根据每年国家统计局发布的优秀企业统计及行业风险数据进行计算",:size=>9}],:align => :left)


      #indent(55) do
      #  credit_lvl = (credit.credit_lvl.present? && credit.credit_lvl || "无")
      #  formatted_text([{:text =>"信用等级: #{credit_lvl}",:size =>12}],:align => :left)
      #  move_down 10
      #  formatted_text([{:text =>"说明:信用等级将根据每年国家统计局发布的优秀企业统计及行业风险数据进行计算",:size=>9}],:align => :left)
      #end


      move_down 100
      pdf_end
      move_down 100
      
      font_size(8) do
      data = [
        ["报告解读:"],
        ["注解 1:","“-”表示信息未获取。"],
        ["注解 2:","财务比率计算公式参考:"],
        ["","毛利率=(主营业务收入-主营业务成本)/主营业务收入×100%"],
        ["","总资产报酬率=(利润总额+利息支出)/平均总资产×100%"],
        ["","营业利润率=营业利润/主营业务收入净额*100%"],
        ["","净资产收益率=净利润/平均所有者权益*100%"],
        ["","资产负债率=负债合计/资产总计*100%"],
        ["","流动比率=流动资产合计/流动负债合计"],
        ["","速动比率=(流动资产合计-存货-预付账款-待摊费用-待处理流动资产净损失)/流动负债合计"],
        ["","应收账款周转速度=主营业务收入/平均应收账款"],
        ["","存货周转速度=主营业务成本/平均存货"],
        ["","总资产周转速度=主营业务收入/平均资产总计"]
      ]
      end
    table(data,:cell_style=>{:inline_format=>true,:border_width => 0},:column_widths => {0 =>80},:width=>430)
      
    end
    render
  end
end

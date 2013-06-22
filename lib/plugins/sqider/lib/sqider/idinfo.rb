#encoding: utf-8
require 'sqider/gateway'

module Sqider
  class Idinfo
    BaseUrl   = "http://www.idinfo.cn"
    #           "http://www.sgs.gov.cn/"
    # === Options
    # [:key]
    # [:type]
    #   :name   --- 名称
    #   :number --- 号码/机构号
    #   :owner  --- 所有者/法人
    def self.where(options = {})
      query_page = QueryPage.new({
        :search_type => :company, 
        :search_field => options[:type], 
        :search_key => options[:key]}
      )
      query_page.detail_links.map { |link| DetailPage.new(link).data }
    end

    class QueryPage
      include Sqider::Gateway
      QUERY_URL = "http://www.idinfo.cn/hzenterprise/hzEnterpriseSearch.action"
      attr_reader :options

      SEARCH_TYPE = {
        :company => 0,
        :commerce => 4900
      }.freeze

      SEARCH_FIELD = {
        :name => 0,
        :number => 1,
        :owner => 2
      }.freeze

      # === Options
      # [:key]
      # [:type]
      #   :name   --- 名称
      #   :number --- 号码
      #   :owner  --- 所有者/法人
      def self.where(options = {})
        QueryPage.new({
          :search_type => :company, 
          :search_field => options[:type], 
          :search_key => options[:key]}
        ).data
      end

      # === Options 
      # [:search_type]
      #   :company
      #   :commerce
      # [:search_field]
      #   :name
      #   :number
      #   :owner
      # [:search_key]
      def initialize(options = {})
        @options = options
      end

      # === Params
      # [:qylx]
      #   0 --- 企业
      #   4900 --- 个体工商户
      # [:searchType]
      #   0 --- 名称 
      #   1 --- 号码
      #   2 --- 所有者/法人
      # [:searchKey]
      def params
        return @params if @params
        @params = {
          :qylx => SEARCH_TYPE[options[:search_type]],
          :searchType => SEARCH_FIELD[options[:search_field]],
          :searchKey => options[:search_key]
        }
      end

      def doc
        @doc ||= post_doc(QUERY_URL, :query => params)
      end

      def data
        @data ||= {:detail_links => detail_links, :names => names, :numbers => numbers}
      end

      def detail_links
        @detail_links ||= doc.css(".listBox").map do |box| 
          first_href = box.css("h1 > a").first['href'] 
          if first_href =~ /(\d{3})$/
            first_href
          else
            second_href = box.css("h1 > a")[1] && box.css("h1 > a")[1]['href'] 
            second_href.scan /(\d+)$/
            "/SignHandle?userID=#{$1}"
          end
        end
      end

      def names
        @names ||= doc.css(".listBox").map do |box| 
          box.css("h1 > a").first.content 
        end 
      end

      def numbers
        @numbers ||= doc.css(".listBox p").map do |regist| 
          regist.children.last.content
        end 
      end
    end

    class DetailPage
      include Sqider::Gateway

      FIELD_SELECTER = {
        regist_id:             "#enrolID",
        name:                  "#name",
        address:               "#add",
        owner:                 "#frdb",
        regist_capital:        "#zczj",
        paid_in_capital:       "#sjcze",
        company_type:          "#gslx",
        found_date:            "#clrq",
        business_scope:        "#jyfw",
        business_start_date:   "#yxqbegin",
        business_end_date:     "#yxqend",
        regist_org:            "#fzjg",
        approved_date:         "#nyr",
      }

      def initialize(url)
        @url = url
      end

      def doc
        @doc ||= get_doc(url, :headers => {"Referer" => Idinfo::QueryPage::QUERY_URL })
      end

      def url
        @url.match(/http:/) ? @url : Idinfo::BaseUrl + @url
      end

      def data
        digital_user? ? digital_user_data : non_digital_user_data
      end

      def digital_user_data
        return @data if @data
        @data = {}
        FIELD_SELECTER.each do |field, selector|
          field_ele = doc.css(selector).first
          @data[field] = field_ele && field_ele.content
        end

        @data[:check_years] = check_years.join(',')

        @data[:orig_url] = url

        @data
      end

      def non_digital_user_data
        return @data if @data
        @data = {}
        left_ele = doc.css("div.left").first
        return @data unless left_ele

        content = left_ele.content
        @data[:regist_id]      = content[/工商注册号：(\d+)/m, 1]
        @data[:name]           = content[/企业名称：(.*?)\s+法人/m, 1]
        @data[:owner]          = content[/法人：(.*?)\s+注册资本/m, 1]
        @data[:regist_capital] = content[/注册资本：(.*?)\s+经营场所/m, 1]
        @data[:address]        = content[/经营场所：(.*?)\s+登记机关/m, 1]
        @data[:regist_org]     = content[/登记机关：(.*)/m, 1]

        @data[:orig_url] = url

        @data
      end

      def digital_user?
        @digital_user ||= !doc.to_s.match(/非数字证书用户/) 
      end

      def check_years
        return @check_years if @check_years
        year_checks = doc.css("#njth img").map { |img| img['src'] }
        @check_years = year_checks.map { |check| check[/\d{2}/, 0] }
      end
    end

  end
end

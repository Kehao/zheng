#encoding: utf-8
require 'sqider/gateway'

module Sqider
  class Court
    # == Options
    # [:name]
    # [:card_number]
    # Sqider::Court.where(name: "杭州盛华皮衣有限公司")
    # Sqider::Court.where(card_number: "3301221985")
    def self.where(options = {})
      CourtGov.where(options)
    end

    module CourtGov
      CHARSET = "utf-8"
      HOST = "http://zhixing.court.gov.cn"

      # == Options
      # [:name]
      # [:card_number]
      # Sqider::Court::CourtGov.where(name: "杭州盛华皮衣有限公司", card_number: ...)
      def self.where(options = {})
        total_query_data(options)
      end

      def self.total_query_data(options = {})
        link_ids = []
        query_page = QueryPage.new(options)
        link_ids.concat(query_page.data)

        2.upto(query_page.total_page) do |page|
          link_ids.concat QueryPage.new(options.merge(:page => page)).data
        end if (query_page.total_page && query_page.total_page > 1)

        total_data = link_ids.map do |id|
          CaseDetailPage.new(id).data
        end
      end

      class QueryPage
        include Sqider::Gateway
        QUERY_URL = "#{HOST}/search/search"

        attr_reader :options
        def initialize(options = {})
          @options = options
          @options[:page] ||= 1
        end

        def doc
          @doc ||= post_doc(QUERY_URL, :body => {:pname => options[:name], :currentPage => options[:page], :cardNum => options[:card_number]})
        end

        def total_page
          return @total_page if @total_page
          total_page_ele = doc.at_css('div[align="right"]')
          @total_page = total_page_ele && total_page_ele.content[/\/(\d+)/, 1].to_i
        end

        def data
          @data ||= links_data
        end

        def links_data
          return @links_data if @links_data
          results = doc.at_css("table#Resultlist")
          link_nodes = results.css("a.View")
          @links_data = link_nodes.map { |node| node['id']}
        end
      end

      class CaseDetailPage
        attr_accessor :url
        URL = "http://zhixing.court.gov.cn/search/detail?id=%s"
        # === Parameters
        # * id
        def initialize(id)
          @url = URL % id
        end

        def data
          return @data if @data
          response = HTTParty.get(url)
          @data = {
            'party_name'  => response['pname'],
            'card_number' => response['partyCardNum'],
            'case_id'     => response['caseCode'],
            'reg_date'    => response['caseCreateTime'],
            'case_state'  => response['caseState'],
            'apply_money' => response['execMoney'],
            'court_name'  => response['execCourtName'],
            'orig_url'    => url
          }
        end
      end
    end

    module Zxaj
      CHARSET = "gb2312"
      HOST = "http://www.zxaj.cn"

      # == Options
      # [:name]
      # [:card_number]
      # Sqider::Court::Zxaj.where(name: "杭州盛华皮衣有限公司")
      def self.where(options)
        total_query_data(options)
      end

      def self.total_query_data(options = {})
        results = []
        query_page = QueryPage.new(options)
        results.concat(query_page.data)

        2.upto(query_page.total_page) do |page|
          results.concat QueryPage.new(options.merge(:page => page)).data
        end if (query_page.total_page && query_page.total_page > 1)

        results
      end

      class QueryPage
        include Sqider::Gateway
        QUERY_URL = "http://www.zxaj.cn/search/?type=public&PartyName=%s&CardNumber=%s&Submit=查 询&zx_next_page=%s"

        DATA_NAMES = {
          'party_id'     =>  '被执行人ID', 
          'party_name'   =>  '被执行人姓名/名称', 
          'card_number'  =>  '身份证号码/组织机构代码',
          'case_id'      =>  '案号',
          'reg_date'     =>  '立案时间',
          'case_state'   =>  '案件状态',
          'apply_money'  =>  '执行标的',
          'court_name'   =>  '执行法院'
        } 

        attr_reader :options


        def initialize(options = {})
          @options = options
        end

        def doc
          @doc ||= get_doc(url) 
        end

        def detail_links
          return @detail_links if @detail_links
          name_nodes = doc.xpath('//a[@title]')
          @detail_links = name_nodes.map { |node| node.parent.parent.children[-2].at_css('a')['href']}
        end

        def total_page
          return @total_page if @total_page
          total_page_ele = doc.xpath("//font").last
          @total_page = total_page_ele && total_page_ele.content[/\/(\d+)/, 1].to_i
        end

        def data
          @data ||= links_data
        end

        def links_data
          @links_data ||= detail_links.map { |link| CaseDetailPage.new(link).data }
        end

        private
        # === Step
        #   1. 传入参数format query url
        #   2. 将地址编码为gb2312格式
        #   3. 用URI编码
        def url #:nodoc:
          return @url if @url
          url = QUERY_URL % [options[:name], options[:card_number], options[:page]]
          @url = URI.encode(url.encode(Court::CHARSET, :invalid => :replace, :undef => :replace))
        end
      end

      class CaseDetailPage
        attr_accessor :url
        # === Parameters
        # * url_or_href:
        #   href 是查询页面"查看"链接的href属性，详细页面的链接可以根据这个构造
        def initialize(url_or_href)
          if url_or_href =~ /^http/
            @url = url_or_href
          else
            @href = url_or_href  # @href 是GB2312编码
            @url = generate_url(url_or_href) 
          end
        end

        def data
          @data ||= @href ? data_from_href : {}
        end

        def data_from_href
          data = {}
          href_data  = URI.decode(@href.to_s).encode('utf-8', Court::CHARSET, :invalid => :replace, :undef => :replace)
          param_data = href_data[/param\=.*?(\{.*\})/, 1] 
          param_data = param_data.gsub(/s\:\d+\:/,'')
          param_data = param_data[/{(.*);}/, 1]
          param_data = param_data.gsub(/"/,'')
          param_data = param_data.split(";")
          param_data.each_with_index do |param, index| 
            next if index.odd? 
            data[param] = param_data[index + 1]
          end

          data[:orig_url] = url

          data
        end

        private
        def generate_url(href)
          pre_path = Court::HOST + '/search/index.php?act=detail&'
          param = href[/(param=.*?)&Submit=.*$/m, 1]
          pre_path + param
        end
      end
    end
  end
end

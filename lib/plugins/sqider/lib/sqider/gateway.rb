#encoding: utf-8
require 'nokogiri'
require 'httparty'

module Sqider
  module Gateway
    extend self
    TIMEOUT = 60

    AM_KEY  = "ba47e4842f884b7a977cfa4006f05e69"
    AM_URL  = "http://126.am/api!shorten.action"
    def shorten_it(a_url)
      response = HTTParty.post(AM_URL, query: {key: AM_KEY, longUrl: a_url})
      if response.code == 200
        response.to_a.last.last
      else
        "error."
      end
    end
  
    # === Options
    # [:timeout]
    #   Specify request timeout, default 20s and other options is Httparty options
    def get_doc(uri, options = {})
      options[:timeout] ||= TIMEOUT
      begin
        page = HTTParty.get(uri, options).to_s
        Nokogiri::HTML(conv_page(page))
      rescue Exception => e
        # Fake a doc instance to avoid nil error
        Nokogiri::HTML('')
      end
    end
  
    # === Parameters
    # *url
    #   Specify the url to request
    # *options
    #   Same as HTTParty options
    def post_doc(url, options = {})
      options[:timeout] ||= TIMEOUT

      begin
        page = HTTParty.post(url, options).to_s
        Nokogiri::HTML(conv_page(page))
      rescue Exception => e
        # Fake a doc instance to avoid nil error
        Nokogiri::HTML('')
      end
    end
  
    private
    def conv_page(page)
      charset = get_charset(page)
  
      if charset && !['UTF8', 'utf8', 'UTF-8', 'utf-8'].include?(charset)
        conved_page = page.encode(
          'utf-8', 
          charset, 
          :invalid => :replace, 
          :undef => :replace, 
          :universal_newline => true
        )
      end
  
      conved_page || page
    end
  
    def get_charset(page)
      page =~ /charset\s*?=\s*?['"]?([^'"]*)['"]?/
      $1
    end
  end
end

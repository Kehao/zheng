#encoding: utf-8
$:.unshift File.expand_path("../../lib", __FILE__) unless $:.include?(File.expand_path("../../lib", __FILE__))
require "sqider"
require 'json'

jj Sqider::Court.where(:name => '方兴东')
jj Sqider::Idinfo.where(:key => '全球网', :type => :name)

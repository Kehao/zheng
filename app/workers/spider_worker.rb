#encoding: utf-8
class SpiderWorker
  include Sidekiq::Worker
  sidekiq_options queue: "spider"

  def perform(spider_id, options = {})
    spider = Spider.find(spider_id)
    spider.run options
  end
end

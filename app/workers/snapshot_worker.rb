#encoding: utf-8
#xvfb-run --server-args="-screen 0, 1024x768x24" ./CutyCapt --url=http://www.zol.com.cn --out=zol.png
class SnapshotWorker
  include Sidekiq::Worker
  sidekiq_options queue: "snapshot"
  sidekiq_options retry: false

  def perform(crime_id=nil)
    if crime_id
      crime = Crime.find(crime_id)
      crime.get_snapshot
    else
      Crime.find_each do |crime|
        crime.get_snapshot
      end
    end
  end
end

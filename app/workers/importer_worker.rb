#encoding: utf-8
class ImporterWorker
  include Sidekiq::Worker
  sidekiq_options queue: "importer"
  sidekiq_options retry: false

  def perform(importer_id)
    importer = Importer.find(importer_id)
    importer.import
  end
end

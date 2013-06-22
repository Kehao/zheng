#encoding: utf-8
class ListFileWorker
  include Sidekiq::Worker
  sidekiq_options queue: "list_file"

  def perform(list_file_id)
    list_file = ListFile.find(list_file_id)
    list_file.import
  end
end

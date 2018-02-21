module SpreeSpringboard
  class FullInventoryImportJob < ApplicationJob
    queue_as :springboard

    def perform
      job = SpreeSpringboard::InventoryImport::Full.new
      job.perform
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Full Inventory Import' })
    ensure
      job.unlock if job.in_progress?
    end
  end
end

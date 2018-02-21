module SpreeSpringboard
  class IncrementalInventoryImportJob < ApplicationJob
    queue_as :springboard

    def perform
      job = SpreeSpringboard::InventoryImport::Incremental.new
      job.perform
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Incremental Inventory Import' })
    ensure
      job.unlock if job.in_progress?
    end
  end
end

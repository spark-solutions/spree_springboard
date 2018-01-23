module SpreeSpringboard
  class IncrementalInventoryImportJob < ApplicationJob
    queue_as :springboard

    def perform
      SpreeSpringboard::InventoryImport::Incremental.new.perform
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Incremental Inventory Import' })
      raise error
    end
  end
end

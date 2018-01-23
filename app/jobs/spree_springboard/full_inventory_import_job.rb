module SpreeSpringboard
  class FullInventoryImportJob < ApplicationJob
    queue_as :springboard

    def perform
      SpreeSpringboard::InventoryImport::Full.new.perform
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: 'Full Inventory Import' })
      raise error
    end
  end
end
